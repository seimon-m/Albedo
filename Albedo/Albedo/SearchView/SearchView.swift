//
//  SearchView.swift
//  Albedo
//
//  Created by Jonas Wolter on 23.11.20.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            Text("Search")
            MapView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
