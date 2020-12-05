//
//  LoadingView.swift
//  Albedo
//
//  Created by Simon Müller on 30.11.20.
//

import SwiftUI

struct LoadingView: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 20)
                .frame(width: 100, height: 100)
 
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color("Green"), lineWidth: 15)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 415 : 55))
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
        }
    }
}



struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
