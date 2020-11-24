//
//  SwiftUIView.swift
//  Albedo
//
//  Created by Jonas Wolter on 22.11.20.
//
import SwiftUI
import Foundation


struct ScrapingView: View {
    
//    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        
//        List(dataManager.searchResults){ flat in
//            Text(flat.title)
//        }
        Text("Scraping...")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapingView()
    }
}
