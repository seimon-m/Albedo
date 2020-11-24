//
//  SearchView.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var dataManager = DataManager.shared
    var body: some View {
        VStack {
            Text("Search")
            MapView()
            List(dataManager.searchResults){ flat in
                Text(flat.title)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
