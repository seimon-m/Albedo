//
//  FavoriteView.swift
//  Albedo
//
//  Created by Jonas Wolter on 07.12.20.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favorites = Favorites.shared
    @State var render = 0
    
    init(){
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "DMSans-Bold", size: 36)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "DMSans-Bold", size: 20)!]
        
            UIBarButtonItem.appearance()
                .setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "DMSans-Regular", size: 17)!],
                                     for: .normal)
       
    }
    
    var body: some View {
        

        
        ZStack {
            Color(red: 0.958, green: 0.958, blue: 0.958).ignoresSafeArea()
            
            ScrollView {
                LazyVStack {
                    ForEach(favorites.flats){ flat in
                        NavigationLink(destination: DetailView(flat: flat)) {
                            CardView(flat: flat)
                        }.padding(.bottom)
                    }
                }
            }
            .navigationBarTitle("Favoriten", displayMode: .inline)
            .padding()
            
        }.onAppear{
            print("Hellou: " + favorites.flats.description)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
