//
//  DatingView.swift
//  Albedo
//
//  Created by Simon Müller on 24.11.20.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * -10))
    }
}

struct DatingView: View {
    @ObservedObject var data = DataManager.shared
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            Text("Date deine WG").font(.largeTitle).bold()
            
                    ZStack {
                        ForEach(0..<data.searchResults.count, id: \.self) { index in
                            ImageCardView(flat: data.searchResults[index])
                                .stacked(at: index, in: data.searchResults.count)
                        }
            }
            
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
