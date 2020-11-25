//
//  SearchView.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var data = DataManager.shared
    var body: some View {
        
        ZStack {
            Color(red: 0.958, green: 0.958, blue: 0.958)
                .ignoresSafeArea()
            VStack {
                Text("Search")
                    .font(.title)
                Text(data.searchResults.count.description + " Resultate")
                    .font(.subheadline)
                MapView()
                ScrollView {
                    LazyVStack{
                        ForEach(data.searchResults){ flat in
                            CardView(flat: flat).padding(.bottom)
                        }
                    }
                }
            }.padding()
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
