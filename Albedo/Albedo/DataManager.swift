//
//  DataManager.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import Foundation
import Alamofire
import SwiftSoup
import MapKit

extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
    func extractAll(left: String, right: String) -> [String]{
        let leftRanges = self.ranges(of: left)
//        print("leftRanges: " + leftRanges.description)
        let rightRanges = self.ranges(of: right)
//        print("rightRanges: " + rightRanges.description)
        
        var result:[String] = []
        
        let up = min(leftRanges.count, rightRanges.count) - 1
        for i in 0...up{
            let rightRange = rightRanges[i]
            let leftRange = leftRanges[i]
            let rangeOfTheData = leftRange.upperBound..<rightRange.lowerBound
            let grabbed = self[rangeOfTheData]
            result.append(String(grabbed))
        }
        return result;
    }
    
    func clean(removeStrings:[String]) -> String{
        var me = self
        for removeString in removeStrings{
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
    
    @Published var searchResults: [String]?
    
    static let shared = DataManager()
    
    init() {
        NSLog("Before Request")
        
        let url = "https://www.wgzimmer.ch/wgzimmer/search/mate.html?query=&priceMin=200&priceMax=1500&state=luzern&permanent=all&student=none&orderBy=%40sortDate&orderDir=descending&startSearchMate=true&wgStartSearch=true&start=0"
        
        requestHtmlString(url: url) { (htmlString) -> () in
            
            NSLog("After Request")
            
            // Bearbeitung
            let leftStr = """
            </script> <a href="/de/wgzimmer/search/mate/
            """
            let rightStr = """
            "> <span class="create-date left-image-result">
            """
            let cleanupStr = """
            " class="search-mate-entry-promoted
            """
            
            let resultStrings = htmlString.extractAll(left: leftStr, right: rightStr).map{ $0.clean(removeStrings: [cleanupStr])}
            NSLog("After Edit")
            
            for resultString in resultStrings{
                let roomUrl = "https://www.wgzimmer.ch/de/wgzimmer/search/mate/" + resultString
                self.requestHtmlString(url: roomUrl) { (html) -> () in
                    do{
                        
                        print(roomUrl)

                        let doc = try SwiftSoup.parse(html)
                        let adressInfos : Elements = try doc.select("div.wrap.col-wrap.adress-region p")
                        
                        let street = try adressInfos[1].text().clean(removeStrings: ["Adresse "])
                        print(street)
                        let zipAndPlace = try adressInfos[2].text().clean(removeStrings: ["Ort "]).components(separatedBy: " ")
                        let zip : Int = Int(zipAndPlace[0])!
                        let place : String = zipAndPlace[1]
                        print(zip)
                        print(place)
                        
                        let roomDescriptionElems : Elements = try doc.select("div.wrap.col-wrap.mate-content.nbb p:not(strong)")
                        let roomDescription = try roomDescriptionElems[0].text().replaceFirstOccurrence(of: "Das Zimmer ist", with: "Das Zimmer ist ")
                        print(roomDescription)
                        
//                        let flat = Flat()
    
                    }catch{
                        print("Couldn't parse html")
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    func startSearch(region: String) {
        
    }
    
    func test() {
        let str = "hellou i rule over all the data"
        print(str)
        let modified = str.clean(removeStrings: ["all ", "rule ", "over "])
        print(str)
        print(modified)
    }
    
    func requestHtmlString(url: String, callback: @escaping (String) -> Void){
        AF.request(url).responseString { response in
            guard let str = response.value else{
                print("Couldn't get htmlString")
                return
            }
            callback(str)
        }
        
        //        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
        //            guard let data = data else {
        //                print("data was nil")
        //                return
        //            }
        //            guard let htmlString = String(data: data, encoding: .utf8)
        //            else {
        //                print("couldn't cast data into String")
        //                return
        //            }
        //
        //            NSLog("Got Result")
        //
        //            let leftStr = """
        //            </script> <a href="/de/wgzimmer/search/mate/
        //            """
        //            let rightStr = """
        //            "> <span class="create-date left-image-result">
        //            """
        //
        //            let cleanupStr = """
        //            " class="search-mate-entry-promoted
        //            """
        //
        //            let resultStrings = htmlString.extractAll(left: leftStr, right: rightStr).map{ $0.clean(removeStrings: [cleanupStr])}
        //
        //            print(resultStrings)
        //            NSLog("After Scrape")
        //        }
        //        task.resume()
    }
    
    //    func extractAll(htmlString, leftSideString, rightSideString)
}
