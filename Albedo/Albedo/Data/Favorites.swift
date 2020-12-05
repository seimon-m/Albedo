//
//  Favorites.swift
//  Albedo
//
//  Created by Jonas Wolter on 30.11.20.
//

import Foundation

class Favorites: ObservableObject {
    
    static let shared = Favorites()
    
    @Published var likedFlatsURLs : [String] = []
    
//    @Published var likedFlatsURLs : [String] {
//        set {
//            saveToDefaults()
//        }
//    }
    
    
    
    private init() {
        print("Favorites created")
        loadFromDefaults()
    }
    
    func loadFromDefaults(){
        
    }
    
    func saveToDefaults(){
        let defaults = UserDefaults.standard
//        var count = defaults.integer(forKey: "DetailViewAppearanceCount")
//        count += 1;
//        self.labelAppearanceCounter.text = "Total View Appearance: " + count.description;
//        defaults.set(count, forKey: "DetailViewAppearanceCount")
    }
    
}
