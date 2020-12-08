//
//  LikeButton.swift
//  Albedo
//
//  Created by Jonas Wolter on 06.12.20.
//

import SwiftUI

struct LikeButton: View {
    @State var updater = false
    @Binding var flat : Flat
    
    var body: some View {
        Button(action: {
            flat.liked.toggle()
            updater.toggle()
        }) {
            // Hacky fix to force view to update
            if(updater){}
            Image(flat.liked ? "liked" : "notLiked")
                .resizable()
                .scaledToFit()
                .frame(height: 22)
                .padding()
                .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.7), radius: 16, y:2)
        }
    }
}
