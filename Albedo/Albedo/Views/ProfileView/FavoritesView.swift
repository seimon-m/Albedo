//
//  FavoriteView.swift
//  Albedo
//
//  Created by Jonas Wolter on 07.12.20.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favorites = Favorites.shared
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(favorites.flats){ flat in
                    NavigationLink(destination: DetailView(flat: flat)) {
                        CardView(flat: flat)
                    }
                }
            }
        }
        .navigationBarTitle("Favoriten", displayMode: .large)
        .padding()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
