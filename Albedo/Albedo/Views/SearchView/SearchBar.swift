//
//  SearchBar.swift
//  Albedo
//
//  Created by Jonas Wolter on 09.12.20.
//

import SwiftUI
import CoreLocation

struct SearchBar: View {
    @Binding var region : Region
    @State var showingFilterView = false
    @State var searchText : String = "Luzern"
    
    @State var dateOn = false
    @State var date = Date()
    @State var perpetualOn = false
    @State var maxPrice : Double = 1500
    
    let dataManager = DataManager.shared
    
    func startSearch(){
        let region = Regions.getRegion(searchString: searchText)
        if(region != nil){
            print("Start Search, String: " + searchText)
            
            self.region = region!
            
            var params = DataManager.QueryParameters()
            
            params.state = region!.queryKey
            params.permanent = perpetualOn ? "true" : "all"
            params.priceMax = Int(maxPrice)
            
            if(dateOn){
                dataManager.setFilterDate(date: date)
            }else{
                dataManager.deleteFilterDate()
            }
            
            dataManager.startQuery(parameters: params)
            
           
        } else{
            print("Search string not found: " + searchText)
        }
    }
    
    var body: some View {
        HStack {
            TextField("Suchen", text: $searchText, onCommit: {
                self.startSearch()
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
                FilterView(isPresented: $showingFilterView, dateOn: $dateOn, date: $date, perpetualOn: $perpetualOn, maxPrice: $maxPrice,
                           callback: {
                                self.startSearch()
                           })
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
    @State static var region : Region = Regions.defaultRegion
  
    static var previews: some View {
        SearchBar(region: $region)
    }
}
