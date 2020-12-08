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
    private let favorites = Favorites.shared
    var body: some View {
        VStack {
            Spacer(minLength: 150)
            Text("Swipe dich zu deiner WG")
                .font(.custom("DMSans-Bold", size: 28))
                .multilineTextAlignment(.center)
            
            if data.loadingComplete {
                Spacer(minLength: 150)
                CardStack(
                  direction: LeftRight.direction,
                    data: data.searchResults,
                  onSwipe: { card, direction in
                    print("Swiped \(card.place) to \(direction)")
                    if direction == .right {
                        swipeHandler(flat: card)
                    }
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
                )
                .frame(width: 350, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .zIndex(2.0)
                HStack {
                    VStack {
                        Image("arrow_left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Kein Interesse")
                            .font(.custom("DMSans-Regular", size: 16))
                            .foregroundColor(Color("Blue"))
                    }
                    
                    Spacer()
                    VStack {
                        Image("arrow_right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Zu den Favoriten")
                            .font(.custom("DMSans-Regular", size: 16))
                            .foregroundColor(Color("Green"))
                    }
                }
                .offset(y: -150)
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                Spacer()
            } else {
                LoadingView().frame(width: 350, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding().offset(y: -50)
            }
        }
        .padding()
        .background(Color("LightGrey"))
    }
    
    func swipeHandler(flat: Flat) {
        favorites.addFavorite(url: flat.url)
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView()
    }
}
