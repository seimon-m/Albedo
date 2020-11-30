//
//  ContentView.swift
//  Albedo
//
//  Created by Simon Müller on 21.11.20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                DatingView()
                    .tabItem {
                        Image("dating")
                        Text("WG-Dating")
                    }.tag(0)
                SearchView()
                    .tabItem {
                        Image("suche")
                        Text("Suche")
                    }.tag(1)
                DatingView()
                    .tabItem {
                        Image("profil")
                        Text("Profil")
                    }.tag(1)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
