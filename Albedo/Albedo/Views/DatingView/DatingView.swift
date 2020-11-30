//
//  DatingView.swift
//  Albedo
//
//  Created by Simon Müller on 24.11.20.
//

import SwiftUI
import CardStack


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * -10))
    }
}

struct DatingView: View {
    @ObservedObject var data = DataManager.shared
    @State var swipePosition = 0
    var body: some View {
        VStack {
            Text("Date deine WG").font(.custom("DMSans-Bold", size: 36))
            if data.loadingComplete {
                CardStack(
                  direction: LeftRight.direction,
                    data: data.searchResults,
                  onSwipe: { card, direction in
                    print("Swiped \(card.place) to \(direction)")
                    swipeHandler(flat: card)
                  },
                  content: { flat, direction, isOnTop in
                    ImageCardView(flat: flat)
                  }
                )
                .environment(
                  \.cardStackConfiguration,
                  CardStackConfiguration(
                    maxVisibleCards: 5,
                    swipeThreshold: 0.1,
                    cardOffset: 30,
                    cardScale: 0.2,
                    animation: .linear
                  )
                )
            } else {
                LoadingView().frame(width: .infinity, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
    }
    
    func swipeHandler(flat: Flat) {
        print("Set to favorites")
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView()
    }
}
