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
    
    
    private init() {
        print("Favorites created")
        loadFromDefaults()
    }
    
    func loadFromDefaults(){
        likedFlatsURLs = UserDefaults.standard.stringArray(forKey: "likedFlatsURLs") ?? [String]()
        print("Favorites loaded: " + likedFlatsURLs.description)
    }
    
    func saveToDefaults(){
        UserDefaults.standard.set(likedFlatsURLs, forKey: "likedFlatsURLs")
        print("Favorites saved: " + likedFlatsURLs.description)
    }
    
    func addFavorite(url: String){
        likedFlatsURLs.append(url)
        saveToDefaults()
    }
    
    func removeFavorite(url: String){
        likedFlatsURLs = likedFlatsURLs.filter(){$0 != url}
        saveToDefaults()
    }
    
}
