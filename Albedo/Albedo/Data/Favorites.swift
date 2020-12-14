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
    @Published var flats : [Flat] = []
    
    
    private let dataManager = DataManager.shared
    
    private init() {
        print("Favorites created")
        loadFromDefaults()
        
    }
    
    func loadFromDefaults(){
        likedFlatsURLs = UserDefaults.standard.stringArray(forKey: "likedFlatsURLs") ?? [String]()
        print("Favorites loaded: " + likedFlatsURLs.description)
        updateFlats()
    }
    
    func saveToDefaults(){
        UserDefaults.standard.set(likedFlatsURLs, forKey: "likedFlatsURLs")
        print("Favorites saved: " + likedFlatsURLs.description)
        updateFlats()
    }
    
    func addFavorite(url: String){
        if !likedFlatsURLs.contains(url){
            likedFlatsURLs.append(url)
            saveToDefaults()
        }
    }
    
    func removeFavorite(url: String){
        likedFlatsURLs = likedFlatsURLs.filter(){$0 != url}
        saveToDefaults()
    }
    
    func updateFlats(){
        self.flats = []
        for url in likedFlatsURLs{
            dataManager.loadFlatData(flatURL: url, parameters: DataManager.QueryParameters()){ flat, parameters in
                self.flats.append(flat)
            }
        }
    }
    
}
