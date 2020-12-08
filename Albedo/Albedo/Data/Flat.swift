//
//  Flat.swift
//  Albedo
//
//  Created by Jonas Wolter on 24.11.20.
//

import Foundation
import CoreLocation

struct Flat : Identifiable, Equatable  {

    var id : String {
        return url
    }
    
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
    let startDate: Date
    func getStartDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: startDate)
    }
    
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
    
    static func == (lhs: Flat, rhs: Flat) -> Bool {
        return lhs.id == rhs.id
    }
}
