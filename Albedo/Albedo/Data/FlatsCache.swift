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
//            print("Replaced in Cache")
        }else{
            flats.append(flat)
//            print("Added to Cache")
        }
    }
}
 
