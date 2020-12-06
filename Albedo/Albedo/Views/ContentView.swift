//
//  ContentView.swift
//  Albedo
//
//  Created by Simon Müller on 21.11.20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
                DatingView()
                    .tabItem {
                        Image("dating")
                        Text("WG-Match")
                    }.tag(0)
                SearchView()
                    .tabItem {
                        Image("suche")
                        Text("Suche")
                    }.tag(1)
                ProfileView()
                    .tabItem {
                        Image("profil")
                        Text("Profil")
                    }.tag(2)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
