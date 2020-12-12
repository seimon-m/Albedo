//
//  ImageCardView.swift
//  Albedo
//
//  Created by Simon Müller on 24.11.20.
//

import SwiftUI
import CardStack

struct ImageCardView: View {
    var flat: Flat
    let direction: LeftRight?
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)){
            if(flat.hasImages){
                let url = URL(string: flat.highResImageURLs[0])!
                AsyncImage(url: url)
                    .conditionalModifier(direction == .right) {
                        $0.colorMultiply(Color(red: 0.000, green: 0.749, blue: 0.514, opacity: 0.5))
                        
                    }
                    .conditionalModifier(direction == .left) {
                        $0.colorMultiply(Color(red: 0.314, green: 0.608, blue: 0.961, opacity: 0.5))
                    }
                    .frame(width: 350 ,height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    
            }else{
                Image("noPicturePlaceholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350 ,height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            Text(String(flat.price) + " Fr.")
                .padding(4)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
                .background(Color.white)
                .cornerRadius(5.0)
                .font(.body)
                .offset(x: 15.0, y: -15.0)
        }

    }
}

extension View {
  @ViewBuilder func conditionalModifier<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    
    if condition {
        transform(self)
    } else {
        self
    }
  }
}


