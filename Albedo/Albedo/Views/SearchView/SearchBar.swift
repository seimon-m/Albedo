//
//  SearchBar.swift
//  Albedo
//
//  Created by Jonas Wolter on 09.12.20.
//

import SwiftUI
import CoreLocation

struct SearchBar: View {
    @Binding var region : Region?
    @State var showingFilterView = false
    @State var searchText : String = "Luzern"
    
    let dataManager = DataManager.shared
    
    var body: some View {
        HStack {
            TextField("Suchen", text: $searchText, onCommit: {
                
                print("Start Search, String: " + searchText)
                self.region = Regions.getRegion(searchString: searchText)
                print("Replaced Region")
                print(self.region)
                var params = DataManager.QueryParameters()
                params.state = region?.queryKey ?? ""
                
                dataManager.resetQuery()
                dataManager.startQuery(parameters: params)
            })
            .font(.custom("DMSans-Regular", size: 18))
                
            Spacer()
            Button(action: {
                showingFilterView.toggle()
            }) {
                Image("filter")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
            }.sheet(isPresented: $showingFilterView) {
                FilterView(isPresented: $showingFilterView)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(Color(.white))
        .cornerRadius(15)
        .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.07), radius: 15, y: 8)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var region : Region? = Regions.defaultRegion
  
    static var previews: some View {
        SearchBar(region: $region)
    }
}
