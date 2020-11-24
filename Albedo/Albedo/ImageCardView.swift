//
//  ImageCardView.swift
//  Albedo
//
//  Created by Simon Müller on 24.11.20.
//

import SwiftUI

struct ImageCardView: View {
    var image: UIImage
    var price: String
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)){
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(price)
                .padding(4)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
                .background(Color.white)
                .cornerRadius(5.0)
                .font(.body)
                .offset(x: 15.0, y: -15.0)
        }.cornerRadius(15)
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(image: UIImage(named: "wg1")!, price: "370 Fr.")
    }
}
