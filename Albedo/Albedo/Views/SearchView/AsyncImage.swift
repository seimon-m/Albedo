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
                    Text("Lädt...")
                        .frame(maxWidth: .infinity, alignment: .center)
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

//struct AsyncImage_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncImage()
//    }
//}
