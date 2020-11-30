//
//  Flat.swift
//  Albedo
//
//  Created by Jonas Wolter on 24.11.20.
//

import Foundation
import CoreLocation
import CoreImage

class Flat : Identifiable {
    
    init(url: String, roomDescription: String, aboutUsDescription: String, aboutYouDescription: String, street: String, zip: Int, place: String, district: String, price: Int, startDate: String, termination: String, lowResImageURLs: [String], highResImageURLs: [String]) {
        self.url = url
        self.roomDescription = roomDescription
        self.aboutUsDescription = aboutUsDescription
        self.aboutYouDescription = aboutYouDescription
        self.street = street
        self.zip = zip
        self.place = place
        self.district = district
        self.price = price
        self.startDate = startDate
        self.termination = termination
        self.lowResImageURLs = lowResImageURLs
        self.highResImageURLs = highResImageURLs
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.adress) { [weak self] (placemarks, error) in
            
            guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
                print("not able to get coordinate")
                return
            }
//            print("Coord: " + coord.latitude.description + ", " + coord.longitude.description)
            
            DispatchQueue.main.async {
                self?.coordinate = coord
            }
        }
    }
    
    
    
   
    
    
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
    var coordinate: CLLocationCoordinate2D?

    
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
