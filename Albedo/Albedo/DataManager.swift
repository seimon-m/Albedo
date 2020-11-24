//
//  DataManager.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import Foundation
import Alamofire
import SwiftSoup

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
    
    @Published var searchResults: [Flat] = []
    
    static let shared = DataManager()
    
    init() {
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
            .responseString { response in
                guard let html = response.value else{
                    print("Couldn't get flat htmlString")
                    return
                }
                do{
                    let doc = try SwiftSoup.parse(html)
                    let links = try doc.select("li.search-result-entry.search-mate-entry a")
                    for i in stride(from: 1, to: links.count, by: 2) {
                        let flatURL = try "https://www.wgzimmer.ch" + links[i].attr("href")
                        self.loadFlatData(flatURL: flatURL)
//                        print(flatURL)
//                        self.searchResults?.append(" ")
                    }
                    if(links.count == 78){
                        var params = parameters
                        params.start += 39
                        self.startQuery(parameters: params)
                    }
                }catch{
                    print("Couldn't parse html")
                }
                
                
            }
    }
    
    func loadFlatData(flatURL: String){
        
        AF.request(flatURL).responseString { response in
            guard let html = response.value else{
                print("Couldn't get flat htmlString")
                return
            }
            do{
//                print(flatURL)

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
                let startDate = try datePerpetualCost[0].text().clean(remove: ["Ab dem "])
                let termination = try datePerpetualCost[1].text().clean(remove: ["Bis "])
                let priceStr = try datePerpetualCost[2].text().clean(remove: ["Miete / Monat", "sFr.",".–", " ", "'"])
                let price : Int = Int(priceStr) ?? 0
        
                
                
                let flat = Flat(url: flatURL, roomDescription: roomDescription, aboutUsDescription: aboutUsDescription, aboutYouDescription: aboutYouDescription, street: street, zip: zip, place: place, district: district, price: price, startDate: startDate, termination: termination, imageURLs: [""])
                
                self.searchResults.append(flat)
                
                print(flat.title)
                print(self.searchResults.count)
            }catch{
                print("Couldn't parse html")
            }
        }
    }
}