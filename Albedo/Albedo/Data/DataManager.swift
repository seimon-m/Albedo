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
    
    private var currentQuery : QueryParameters?
    private var filterDate : Date? = nil
    
    var totalResults : Int = Int.max
    
    var geocodingTimer : Timer?
    private static let GEOCODING_INTERVAL = 5.1 //in seconds
    private static let GEOCODING_BATCH_SIZE = 50
    
    
    private init() {
        // Deomonstration Purposes: Standardmässig Query für Luzern starten
        var params = QueryParameters()
        params.state = "luzern"
        startQuery(parameters: params)
    }
    
    struct QueryParameters: Encodable, Equatable {
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
        
        static func == (lhs: QueryParameters, rhs: QueryParameters) -> Bool {
            return
                lhs.query == rhs.query &&
                lhs.priceMin == rhs.priceMin &&
                lhs.priceMax == rhs.priceMax &&
                lhs.state == rhs.state &&
                lhs.permanent == rhs.permanent &&
                lhs.student == rhs.student &&
                lhs.country == rhs.country &&
                lhs.orderBy == rhs.orderBy &&
                lhs.orderDir == rhs.orderDir &&
                lhs.startSearchMate == rhs.startSearchMate &&
                lhs.wgStartSearch == rhs.wgStartSearch
        }
        
        
    }
    
    func startQuery(parameters: QueryParameters){
        
        if(parameters == self.currentQuery){ return }
        
        // Reset
        self.currentQuery = parameters
        self.searchResults = []
        self.loadingComplete = false
        self.totalResults = Int.max
        stopGeocoding()
        
        // Start query
        query(parameters: parameters)
    }
    
    private func query(parameters: QueryParameters)  {
        
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
                        print("totalResults: " + self.totalResults.description)
                    }
                    
                    // Alle Links raussuchen und Parsing der WGs starten
                    let links = try doc.select("li.search-result-entry.search-mate-entry a")
                    for i in stride(from: 1, to: links.count, by: 2) {
                        let flatURL = try "https://www.wgzimmer.ch" + links[i].attr("href")
                        
                        self.loadFlatData(flatURL: flatURL, parameters: parameters){ flat, parameters in
                            DispatchQueue.main.async {
                                
                                // Return if query changed in the meantime (prevents concurrency errors)
                                if(parameters != self.currentQuery){ return }
                                
                                self.searchResults.append(flat)
                                FlatsCache.add(flat)
                                print(self.searchResults.count)
                                
                                if(self.searchResults.count == DataManager.GEOCODING_BATCH_SIZE){
                                    self.startGeocoding(queryParameters: parameters)
                                }
                                if(self.searchResults.count >= self.totalResults){
                                    self.loadingComplete = true
                                    print("Loading has completed")
                                    self.startGeocoding(queryParameters: parameters)
                                }
                            }
                        }
                    }
                    // Nächste Seite ebenfalls parsen falls 39 (= Maximalzahl) Inserate auf der Seite sind
                    if(links.count == 78){
                        var params = parameters
                        params.start += 39
                        self.query(parameters: params)
                        
                    }
                }catch{
                    print("Couldn't parse html of query: ")
                    print(parameters)
                }
            }
    }
    
    func loadFlatData(flatURL: String, parameters: QueryParameters, onFlatLoaded: @escaping (Flat, QueryParameters) -> Void){
        
        // Return directly if already in cache
        let flats = FlatsCache.flats.filter{$0.url == flatURL}
        if flats.count >= 1 {
            onFlatLoaded(flats[0], parameters)
            return
        }

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
                    onFlatLoaded(flat, parameters)
                }
            }catch{
                print("Couldn't parse html of " + flatURL)
            }
        }
    }
    
    func setFilterDate(date : Date){
        self.filterDate = date
    }
    
    func deleteFilterDate(){
        self.filterDate = nil
    }
    
    func getFilteredSearchResults() -> [Flat] {
        
        if(filterDate != nil){
            return searchResults.filter{$0.startDate > self.filterDate!}
        }else{
            return searchResults
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
    
    private func startGeocoding(queryParameters: QueryParameters){
        stopGeocoding()
        geocodeBatch(queryParameters: queryParameters)
//        geocodingTimer = Timer.scheduledTimer(timeInterval: DataManager.GEOCODING_INTERVAL, target: self, selector: #selector(geocodeBatch), userInfo: nil, repeats: true)
        
        self.geocodingTimer = Timer.scheduledTimer(withTimeInterval: DataManager.GEOCODING_INTERVAL, repeats: true) { timer in
            self.geocodeBatch(queryParameters: queryParameters)
        }
    }
    
    private func stopGeocoding(){
        geocodingTimer?.invalidate();
    }
    
    // Geocodes one Batch of 50 Adresses (50 is the maximum per minute)
    private func geocodeBatch(queryParameters: QueryParameters){
            
        
//            let missingCoords = self.searchResults.filter{$0.coordinate == nil}
//            print("Coords missing: " + missingCoords.count.description)
                    
            
            var requestsCount = 0
            for i in 0..<self.searchResults.count{
                let flat = self.searchResults[i]
                
                // Break if already sent 50 requests
                if(requestsCount >= DataManager.GEOCODING_BATCH_SIZE) { break }
                // Go to next if flat already has coordinate
                if(flat.coordinate != nil) { continue }
                
                // Start request
                requestsCount += 1
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(flat.adress) { [weak self] (placemarks, error) in
                    guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
                        // return if no coordinate found
                        return
                    }
                    
                    // Wird automatisch auf Main Thread ausgeführt...
                    
                    // Abbrechen falls Query in der Zwischenzeit gewechselt hat
                    if(queryParameters != self!.currentQuery){ return }
                    
                    self!.searchResults[i].coordinate = coord
                    FlatsCache.add(self!.searchResults[i])
                }
            }
            
            if(requestsCount == 0){
                self.stopGeocoding()
            }
        
    }
}
