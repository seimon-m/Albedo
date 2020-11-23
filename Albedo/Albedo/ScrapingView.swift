//
//  SwiftUIView.swift
//  Albedo
//
//  Created by Jonas Wolter on 22.11.20.
//
import SwiftUI
import Foundation

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
}

extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
}


struct ScrapingView: View {
    
    func scrape() {
        
        let baseUrl = "https://www.wgzimmer.ch/wgzimmer/search/mate.html?query=&priceMin=200&priceMax=1500&state=luzern&permanent=all&student=none&orderBy=%40sortDate&orderDir=descending&startSearchMate=true&wgStartSearch=true&start=0"
        let url = URL(string: baseUrl)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            guard let htmlString = String(data: data, encoding: .utf8)
            else {
                print("couldn't cast data into String")
                return
            }
            
            let leftSideString = """
            </script> <a href="/de/wgzimmer/search/mate/
            """
            let rightSideString = """
            "> <span class="create-date left-image-result">
            """
            
            let leftRanges = htmlString.ranges(of: leftSideString)
            let rightRanges = htmlString.ranges(of: rightSideString)
            
            let cleanupString = """
            " class="search-mate-entry-promoted
            """
            
            for (index, leftRange) in leftRanges.enumerated() {
                let rightRange = rightRanges[index]
                let rangeOfTheData = leftRange.upperBound..<rightRange.lowerBound
                let grabbed = htmlString[rangeOfTheData].replacingOccurrences(of: cleanupString, with: "")
                print(grabbed)
            }
        }
        task.resume()
    }
    
    var body: some View {
        Text("Scraping...").onAppear(){
            scrape();
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapingView()
    }
}
