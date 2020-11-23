//
//  SwiftUIView.swift
//  Albedo
//
//  Created by Jonas Wolter on 22.11.20.
//
import SwiftUI
import Foundation


struct ScrapingView: View {
    
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        Text("Scraping...").onAppear(){
//           do something
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapingView()
    }
}
