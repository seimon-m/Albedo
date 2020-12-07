//
//  DataManager.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import Foundation
import Alamofire
import SwiftSoup
import CoreLocation

extension String {
    
    func clean(remove:[String]) -> String{
        var me = self
        for removeString in remove{
            me = me.replacingOccurrences(of: removeString, with: "")
        }
        return me
    }
    
    func replaceFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
}

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    @Published var searchResults: [Flat] = []
    @Published var loadingComplete = false
    
    var totalResults : Int = Int.max
    
    
    
    
    private init() {
        NSLog("Before Query")
        
        var params = QueryParameters()
        params.state = "luzern"
        startQuery(parameters: params)
        
    }
    
    struct QueryParameters: Encodable {
        var query = ""
        var priceMin = 200
        var priceMax = 1500
        var state = "luzern"
        var permanent = "all"
        var student = "none"
        var country = "ch"
        var orderBy = "@sortDate"
        var orderDir = "descending"
        var startSearchMate = true
        var wgStartSearch = true
        var start = 0
    }
    
    func startQuery(parameters: QueryParameters)  {
        let baseURL = "https://www.wgzimmer.ch/wgzimmer/search/mate.html"
        
        AF.request(baseURL, parameters: parameters)
            .responseString(queue: DispatchQueue.global()) { response in
                guard let html = response.value else{
                    print("Couldn't get flat htmlString")
                    return
                }
                do{
                    let doc = try SwiftSoup.parse(html)
                    
                    // Total Anzahl Resultate speichern
                    let scriptsElems = try doc.select("#container #content script")
                    let rmvBefore = """
                    jQuery("#totalAdsFoundHeader").text("Total
                    """
                    let rmvAfter = """
                     WG-Inserate gefunden");
                    """
                    let foundStr = try scriptsElems[scriptsElems.count - 1].html()
                        .clean(remove: [rmvBefore, rmvAfter, " "])
                    DispatchQueue.main.async {
                        self.totalResults = Int(foundStr)!
                    }
                    
                    // Alle Links raussuchen und Parsing der WGs starten
                    let links = try doc.select("li.search-result-entry.search-mate-entry a")
                    for i in stride(from: 1, to: links.count, by: 2) {
                        let flatURL = try "https://www.wgzimmer.ch" + links[i].attr("href")
                        
                        let geocoder = Geocoder(flats: &self.searchResults)
                        
                        self.loadFlatData(flatURL: flatURL){ flat in
                            self.searchResults.append(flat)
                            print(self.searchResults.count)
                
                            if(self.searchResults.count == Geocoder.GEOCODING_BATCH_SIZE){
                                geocoder.startGeocoding()
                            }
                            if(self.searchResults.count >= self.totalResults){
                                self.loadingComplete = true
                                geocoder.startGeocoding()
                            }
                        }
                    }
                    // Nächste Seite ebenfalls parsen falls 39 (= Maximalzahl) Inserate auf der Seite sind
                    if(links.count == 78){
                        var params = parameters
                        params.start += 39
                        self.startQuery(parameters: params)
                    }
                }catch{
                    print("Couldn't parse html of query: ")
                    print(parameters)
                }
            }
    }
    
    func loadFlatData(flatURL: String, onFlatLoaded: @escaping (Flat) -> Void){
        AF.request(flatURL).responseString(queue: DispatchQueue.global()) { response in
            guard let html = response.value else{
                print("Couldn't get flat htmlString")
                return
            }
            do{
                let doc = try SwiftSoup.parse(html)
                let adressInfos : Elements = try doc.select("div.wrap.col-wrap.adress-region p")
                
                let street = try adressInfos[1].text().clean(remove: ["Adresse "])
                let zipAndPlace = try adressInfos[2].text().clean(remove: ["Ort "]).components(separatedBy: " ")
                let zip : Int = Int(zipAndPlace[0]) ?? 0
                let place : String = zipAndPlace[1]
                var district = try adressInfos[3].text().clean(remove: ["Kreis / Quartier "])
                if(district.contains("In der Nähe")){
                    district = place
                }
            
                let roomDescriptionElems : Elements = try doc.select("div.wrap.col-wrap.mate-content.nbb p")
                let roomDescription = try roomDescriptionElems[0].text().replaceFirstOccurrence(of: "Das Zimmer ist", with: "Das Zimmer ist ")
                
                let aboutUsDescription : String = try doc.select("div.wrap.col-wrap.person-content p")[0].text()
                let aboutYouDescription : String = try doc.select("div.wrap.col-wrap.room-content p")[0].text()
                
                let datePerpetualCost = try doc.select("div.wrap.col-wrap.date-cost p")
                let startDateStr = try datePerpetualCost[0].text().clean(remove: ["Ab dem "])
                let dateElements = startDateStr.split(separator: ".")
                let calendar = Calendar.current
                var components = DateComponents()
                components.day = Int(dateElements[0]) ?? 1
                components.month = Int(dateElements[1]) ?? 1
                components.year = Int(dateElements[2]) ?? 2000
                let date : Date = calendar.date(from: components)!
                
                
                let termination = try datePerpetualCost[1].text().clean(remove: ["Bis "])
                let priceStr = try datePerpetualCost[2].text().clean(remove: ["Miete / Monat", "sFr.",".–", " ", "'"])
                let price : Int = Int(priceStr) ?? 0
                
                let imageScriptsElems = try doc.select("div.image script")
                var lowResImgURLs : [String] = []
                var highResImgURLs : [String] = []
                
                for script in imageScriptsElems{
                    let id = self.parseImgIdFromScript(script: try script.html())
                    let lowResURL = "https://img.wgzimmer.ch/.imaging/wgzimmer_medium-jpg/dam/" + id + "/temp.jpg"
                    let highResURL  = "https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/" + id + "/temp.jpg"
                    lowResImgURLs.append(lowResURL)
                    highResImgURLs.append(highResURL)
                }

                let flat = Flat(url: flatURL, roomDescription: roomDescription, aboutUsDescription: aboutUsDescription, aboutYouDescription: aboutYouDescription, street: street, zip: zip, place: place, district: district, price: price, startDate: date, termination: termination, lowResImageURLs: lowResImgURLs, highResImageURLs: highResImgURLs)
                
                DispatchQueue.main.async {
                    onFlatLoaded(flat)
                }
            }catch{
                print("Couldn't parse html of " + flatURL)
            }
        }
    }
    
    private func parseImgIdFromScript (script : String) -> String {
        
        let leftString = """
        xhrRenderImage("
        """
        let rightString = """
        ", "wgzimmer_medium"
        """
        
        let leftSideRange = script.range(of: leftString)!
        let rightSideRange = script.range(of: rightString)!
        let rangeOfTheData = leftSideRange.upperBound..<rightSideRange.lowerBound
        
        return String(script[rangeOfTheData])
    }
    
    
}
