//
//  Flat.swift
//  Albedo
//
//  Created by Jonas Wolter on 24.11.20.
//

import Foundation
import CoreLocation
import CoreImage

struct Flat {
    let url: String
    
    let title: String
    let roomDescription: String
    let aboutUsDescription: String
    let aboutYouDescription: String
    
    let street: String
    let zip: Int
    let place: String
    
    var adress: String { // Computed Property Strasse und PLZ
        return "\(street), \(zip) \(place)"
    }
    
    let coordinate: CLLocationCoordinate2D
    
    let price: Int
    let startDate: Date
    let isPerpetual: Bool
    
    let imageURLs: [String]
//    let images: [CGImage]
}
