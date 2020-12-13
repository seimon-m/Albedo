//
//  ImageGalleryView.swift
//  Albedo
//
//  Created by Simon Müller on 05.12.20.
//

import SwiftUI

struct ImageGalleryView: View {
    var images: [String]

    var body: some View {
            TabView {
                ForEach(0..<images.count) { num in
                    if let url = URL(string: images[num]) {
                        AsyncImage(url: url)
                            .tag(num)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGalleryView(images: ["https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/3a28ebef-5b74-4864-8ab0-02e4a4c2b016/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/8d7ada4f-adec-4a1d-be86-74cb0482ee45/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/53284290-c292-4a3b-be04-ffb683861753/temp.jpg"])
    }
}
