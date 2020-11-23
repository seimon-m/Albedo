//
//  DataManager.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import Foundation
import Alamofire

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
        let rightRanges = self.ranges(of: right)
        
        var result:[String] = []
        for (index, leftRange) in leftRanges.enumerated() {
            let rightRange = rightRanges[index]
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
            
            print(resultStrings.description)
            
            NSLog("After Edit")
            
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
