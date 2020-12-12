//
//  ContentView.swift
//  Albedo
//
//  Created by Simon Müller on 21.11.20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var tabItems = TabItems()
        var body: some View {
            ZStack {
                NavigationView {
                    DatingView()
                        .navigationBarHidden(true)
                        .edgesIgnoringSafeArea(.all)
                }
                .opacity((tabItems.selectedTabIndex == 1) ? 1 : 0)
                NavigationView {
                    SearchView()
                        .navigationBarHidden(true)
                        .edgesIgnoringSafeArea(.all)
                }
                .opacity((tabItems.selectedTabIndex == 2) ? 1 : 0)
                NavigationView {
                    ProfileView()
                        .navigationBarHidden(true)
                        .edgesIgnoringSafeArea(.all)
                }
                .opacity((tabItems.selectedTabIndex == 3) ? 1 : 0)
                TabBar(tabItems: tabItems)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
