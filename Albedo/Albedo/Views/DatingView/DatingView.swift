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
            Spacer(minLength: 100)
            Text("Date deine WG").font(.custom("DMSans-Bold", size: 42))
            if data.loadingComplete {
                Spacer(minLength: 150)
                CardStack(
                  direction: LeftRight.direction,
                    data: data.searchResults,
                  onSwipe: { card, direction in
                    print("Swiped \(card.place) to \(direction)")
                    swipeHandler(flat: card)
                  },
                  content: { flat, direction, isOnTop in
                    ImageCardView(flat: flat, direction: direction)
                  }
                )
                .environment(
                  \.cardStackConfiguration,
                  CardStackConfiguration(
                    maxVisibleCards: 5,
                    swipeThreshold: 0.1,
                    cardOffset: -80,
                    cardScale: 0.1,
                    animation: .linear
                  )
                ).frame(width: 350, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack {
                    VStack {
                        Image("arrow_left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Kein Interesse")
                            .font(.custom("DMSans-Regular", size: 18))
                            .foregroundColor(Color("Blue"))
                    }
                    
                    Spacer()
                    VStack {
                        Image("arrow_right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Zu den Favoriten")
                            .font(.custom("DMSans-Regular", size: 18))
                            .foregroundColor(Color("Green"))
                    }
                }
                .offset(y: -100)
                Spacer()
            } else {
                LoadingView().frame(width: 350, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
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
