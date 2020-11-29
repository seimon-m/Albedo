//
//  Flat.swift
//  Albedo
//
//  Created by Jonas Wolter on 24.11.20.
//

import Foundation
import CoreLocation
import CoreImage

struct Flat : Identifiable {
    
    let id = UUID()
    
    let url: String
    
    var title: String {
        return "Zimmer \(district)"
    }
    let roomDescription: String
    let aboutUsDescription: String
    let aboutYouDescription: String
    
    let street: String
    let zip: Int
    let place: String
    let district: String
    
    var adress: String {
        return "\(street), \(zip) \(place)"
    }
    
//    let coordinate: CLLocationCoordinate2D -> über Apple Maps API laden

    
    let price: Int
    let startDate: String
    let termination: String
    var isPerpetual : Bool {
        return termination.contains("Unbefristet") ? true : false;
    }
    let lowResImageURLs: [String]
    let highResImageURLs: [String]
    
    var hasImages: Bool{
        return highResImageURLs.count > 0
    }
    
//    let images: [CGImage]
}
