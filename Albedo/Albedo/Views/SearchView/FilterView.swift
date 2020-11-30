//
//  FilterView.swift
//  Albedo
//
//  Created by Jonas Wolter on 30.11.20.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var isPresented : Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.958, green: 0.958, blue: 0.958)
                .ignoresSafeArea()
            VStack (alignment: .leading){
                HStack {
                    Text("Filter")
                        .font(.custom("DMSans-Bold", size: 28))
                    Spacer()
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image("approve")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                    }
                }.padding()
                
                Form {
                    Section {
                        Text("Startdatum")
                            .font(.custom("DMSans-Medium", size: 22))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    Section {
                        Text("Unbefristet")
                            .font(.custom("DMSans-Medium", size: 22))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    Section {
                        Text("Maximaler Preis")
                            .font(.custom("DMSans-Medium", size: 22))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }.onAppear{
                    UITableView.appearance().backgroundColor = UIColor(red: 0.958, green: 0.958, blue: 0.958, alpha: 1.0)
                        
                }
                Spacer()
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    @State static var presentFilter : Bool = true
    
    static var previews: some View {
        FilterView(isPresented: self.$presentFilter)
    }
}

