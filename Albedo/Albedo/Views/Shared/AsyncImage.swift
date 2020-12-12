//
//  AsyncImage.swift
//  Albedo
//
//  Created by Jonas Wolter on 29.11.20.
//

import SwiftUI

struct AsyncImage: View {
    
    @StateObject private var loader: ImageLoader
    
    private var content: some View {
            Group {
                if loader.image != nil {
                    Image(uiImage: loader.image!)
                        .resizable()
                        .scaledToFill()
                } else {
                    VStack {
                        Text("Lädt...")
                            .font(.custom("DMSans-Regular", size: 18))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                }
            }
        }
    
    init(url: URL){
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content.onAppear(perform: loader.load)

    }
}

