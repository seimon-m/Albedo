//
//  ContentView.swift
//  Albedo
//
//  Created by Simon Müller on 21.11.20.
//

import SwiftUI

struct ContentView: View {
    
//    @State private var selectedTab = 1
    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//                DatingView()
//                    .tabItem {
//                        Image("dating")
//                        Text("WG-Match")
//                    }.tag(0)
//                SearchView()
//                    .tabItem {
//                        Image("suche")
//                        Text("Suche")
//                    }.tag(1)
//                ProfileView()
//                    .tabItem {
//                        Image("profil")
//                        Text("Profil")
//                    }.tag(2)
//            }
        
//        }
    
    @StateObject var tabItems = TabItems()
        var body: some View {
            ZStack {
                NavigationView {
                    DatingView()
                        .offset(y: -90.0)
                        .edgesIgnoringSafeArea(.all)
                }
                .opacity((tabItems.selectedTabIndex == 1) ? 1 : 0)
                NavigationView {
                    SearchView()
                    .edgesIgnoringSafeArea(.all)
                }
                .opacity((tabItems.selectedTabIndex == 2) ? 1 : 0)
                NavigationView {
                    ProfileView()
                    .edgesIgnoringSafeArea(.top)
                }
                .opacity((tabItems.selectedTabIndex == 3) ? 1 : 0)
                TabBar(tabItems: tabItems)
            }
            .offset(y: 35.0)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
