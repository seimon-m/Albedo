//
//  ProfileView.swift
//  Albedo
//
//  Created by Jonas Wolter on 06.12.20.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        
        
        VStack {
            
            NavigationView {
                
                Form {
                    Section{
                        HStack(alignment: .center) {
                            ZStack {
                                Circle()
                                    .frame(width: 80)
                                    .foregroundColor(Color("Green"))
                                Image("profileWhite")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 36)
                            }.frame(width: 80, height: 80)
                            Text("Simon Müller")
                                .font(.custom("DMSans-Bold", size: 28))
                                .padding()
                        }.frame(height: 100)
                    }
                    
                    Section{
                        NavigationLink(destination:
                                        Text("Einstellungen sind momentan noch nicht verfügbar.").padding().multilineTextAlignment(.center)) {
                            Text("Einstellungen")
                                .font(.custom("DMSans-Medium", size: 20))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }
                    
                    Section{
                        NavigationLink(destination: FavoritesView()) {
                            Text("Favoriten")
                                .font(.custom("DMSans-Medium", size: 20))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }
                    
                }
                .navigationBarTitle(Text("Profil"), displayMode: .large)
            }
            
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
