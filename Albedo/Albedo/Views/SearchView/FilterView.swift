//
//  FilterView.swift
//  Albedo
//
//  Created by Jonas Wolter on 30.11.20.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var isPresented : Bool
    @State var perpetualToggle = false
    @State var dateToggle = false
    @State var maxPrice : Double = 1500
    
    var body: some View {
        ZStack {
            Color(red: 0.958, green: 0.958, blue: 0.958)
                .ignoresSafeArea()
            VStack (alignment: .leading){
                HStack {
                    Text("Suche eingrenzen")
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
                }.padding(24)
                
                Form {
                    Section {
                        Toggle(isOn: $dateToggle) {
                            Text("Einzugsdatum")
                                .font(.custom("DMSans-Medium", size: 20))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        
                        DatePicker("Verfügbar ab", selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, displayedComponents: [.date])
                            .font(.custom("DMSans-Regular", size: 16))
                            .foregroundColor(dateToggle ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.831, green: 0.831, blue: 0.831))
                            .disabled(!dateToggle)
                        
                    }
                    Section {
                        HStack {
                            Toggle(isOn: $perpetualToggle) {
                                Text("Unbefristet")
                                    .font(.custom("DMSans-Medium", size: 20))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                        }
                        
                    }
                    Section {
                        HStack {
                            Text("Maximaler Preis")
                                .font(.custom("DMSans-Medium", size: 20))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            Spacer()
                            Text(String(format: "%.0f", maxPrice) + " CHF")
                                .font(.custom("DMSans-Medium", size: 18))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        
                        Slider(value: $maxPrice, in: 200...1500, step: 10)
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

