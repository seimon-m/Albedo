//
//  DatingView.swift
//  Albedo
//
//  Created by Simon Müller on 24.11.20.
//

import SwiftUI

struct DatingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            Text("Date deine WG").font(.largeTitle).bold()
            ImageCardView(image: UIImage(named: "wg1")!, price: "370 Fr.")
            HStack {
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Dismiss")
                }
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Favor")
                }
            }
            
        }
        .padding(.horizontal)
        
        
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView()
    }
}
