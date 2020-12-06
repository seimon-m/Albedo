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
    var coordinate: CLLocationCoordinate2D? = nil

    
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
    
    private let favorites = Favorites.shared
        
    var liked: Bool {
        get {
            return favorites.likedFlatsURLs.contains(self.url)
        }
        set {
            if(newValue == true){
                favorites.addFavorite(url: self.url)
            }else{
                favorites.removeFavorite(url: self.url)
            }
        }
    }
    
//    let images: [CGImage]
}
