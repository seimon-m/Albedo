//
//  FlatsCache.swift
//  Albedo
//
//  Created by Jonas Wolter on 08.12.20.
//

import Foundation

class FlatsCache {
    static var flats : [Flat] = []

    static func add(_ flat: Flat){
        if let index = flats.firstIndex(of: flat){
            flats[index] = flat
        }else{
            flats.append(flat)
        }
    }
    
    static func printURLs(){
        print(flats.map{$0.url})
    }
}
 
