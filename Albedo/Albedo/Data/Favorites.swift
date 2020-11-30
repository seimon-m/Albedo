//
//  Favorites.swift
//  Albedo
//
//  Created by Jonas Wolter on 30.11.20.
//

import Foundation

class Favorites: ObservableObject {
    
    static let shared = Favorites()
    
    @Published var urls: [String] = []
    
    private init() {
        print("Favorites created")
    }
    
}
