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
    
    @Published var searchResults: [Flat] = []
    @Published var loadingComplete = false
    var totalResults : Int = Int.max
    static let shared = DataManager()
    
    var geocodingTimer : Timer?
    
    
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
                        self.loadFlatData(flatURL: flatURL)
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
    
    func loadFlatData(flatURL: String){
        AF.request(flatURL).responseString(queue: DispatchQueue.global()) { response in
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

                let flat = Flat(url: flatURL, roomDescription: roomDescription, aboutUsDescription: aboutUsDescription, aboutYouDescription: aboutYouDescription, street: street, zip: zip, place: place, district: district, price: price, startDate: startDate, termination: termination, lowResImageURLs: lowResImgURLs, highResImageURLs: highResImgURLs)
                
                DispatchQueue.main.async {
                    self.searchResults.append(flat)
                    print(self.searchResults.count)
                    
                    if(self.searchResults.count == 50){
                        self.startGeocoding()
                    }
                    if(self.searchResults.count >= self.totalResults){
                        self.loadingComplete = true
                        self.startGeocoding()
                    }
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
    
    
    
    private func startGeocoding(){
        stopGeocoding()
        geocodeBatch()
        geocodingTimer = Timer.scheduledTimer(timeInterval: 5.1, target: self, selector: #selector(geocodeBatch), userInfo: nil, repeats: true)
    }
    
    private func stopGeocoding(){
        geocodingTimer?.invalidate();
    }
    
    // Geocodes one Batch of 50 Adresses (50 is the maximum per minute)
    @objc private func geocodeBatch(){
        DispatchQueue.global(qos: .utility).async {
            
            let missingCoords = self.searchResults.filter{$0.coordinate == nil}
            print("Coords missing: " + missingCoords.count.description)
            
//            for flat in missingCoords{
//                print(flat.url + ", ", terminator:"")
//            }
//            print()
            
            
            var requestsCount = 0
            for i in 0..<self.searchResults.count{
                let flat = self.searchResults[i]
                
                // Break if already sent 50 requests
                if(requestsCount >= 50) { break }
                // Go to next if flat already has coordinate
                if(flat.coordinate != nil) { continue }
                
                // Start request
                requestsCount += 1
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(flat.adress) { [weak self] (placemarks, error) in
                    guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
                        //print("not able to get coordinate")
                        return
                    }
                    
                    // Wird automatisch auf Main Thread ausgeführt...
                    // print("Main Thread: " + Thread.isMainThread.description)
                    self?.searchResults[i].coordinate = coord
                }
            }
            
            if(requestsCount == 0){
                self.stopGeocoding()
            }
            
//            let noCoords = self.searchResults.filter{$0.coordinate == nil}
//            if (noCoords.count == 0) {
//                self.stopGeocoding()
//                print("All flat coordinates are complete")
//            }
//
//            for i in 0...min(noCoords.count, 50){
//                let geocoder = CLGeocoder()
//                var flat = noCoords[i]
//
//                geocoder.geocodeAddressString(flat.adress) { [weak self] (placemarks, error) in
//                    guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
//                        //print("not able to get coordinate")
//                        return
//                    }
//
//                    // Wird automatisch auf Main Thread ausgeführt...
//                    // print("Main Thread: " + Thread.isMainThread.description)
//
//                    flat.coordinate = coord
//                    self?.totalCoords += 1
//
//                    NSLog("Total Coords: " + (self?.totalCoords.description)!)
//                }
//            }
        }
    }
    
    
//    private func geocodeAdresses(){
//
//        DispatchQueue.global(qos: .utility).async {
//
//
//            let noCoords = self.searchResults.filter{$0.coordinate == nil}
//            print("Main Thread: " + Thread.isMainThread.description)
//
//            for i in 0...min(noCoords.count, 50){
//                let geocoder = CLGeocoder()
//                var flat = noCoords[i]
//
//                geocoder.geocodeAddressString(flat.adress) { placemarks, error in
//
//                    guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
//                        //print("not able to get coordinate")
//                        return
//                    }
//        //            print("Coord: " + coord.latitude.description + ", " + coord.longitude.description)
//                    print("Main Thread: " + Thread.isMainThread.description)
//
//                    DispatchQueue.main.async {
//                        flat.coordinate = coord
//                        self.totalCoords += 1
//                        NSLog("Total Coords: " + self.totalCoords.description)
//                        //print("FlatCoord: " + flat.coordinate.debugDescription)
//
//    //                    print("Main Thread: " + Thread.isMainThread.description)
//                    }
//                }
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
//                self.geocodeAdresses()
//            }
//
////            DispatchQueue.main.async {
////                print("This is run on the main queue, after the previous code in outer block")
////            }
//        }
        
        
//    }
}
