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
    @State var swipePosition = 0
    var body: some View {
        VStack {
            Text("Date deine WG").font(.custom("DMSans-Bold", size: 36))
            if data.loadingComplete {
                ZStack(alignment: .leading) {
//                    ForEach(0..<5, id: \.self) { index in
//                        ImageCardView(flat:data.searchResults[index]) {
//                            withAnimation {
//                                self.removeCard(at: index)
//                            }
//                        }
//                        .stacked(at: index, in:data.searchResults.count)
//                    }
                    ImageCardView(flat:data.searchResults[self.swipePosition]) {
                        withAnimation {
                            self.swipeHandler(at: self.swipePosition)
                        }
                    }.stacked(at: 0, in:5)
                    ImageCardView(flat:data.searchResults[self.swipePosition + 1]) {
                        withAnimation {
                            self.swipeHandler(at: self.swipePosition + 1)
                        }
                    }.stacked(at: 1, in:5)
                    ImageCardView(flat:data.searchResults[self.swipePosition + 1]) {
                        withAnimation {
                            self.swipeHandler(at: self.swipePosition + 2)
                        }
                    }.stacked(at: 2, in:5)
                    ImageCardView(flat:data.searchResults[self.swipePosition + 3]) {
                        withAnimation {
                            self.swipeHandler(at: self.swipePosition + 3)
                        }
                    }.stacked(at: 3, in:5)
                    ImageCardView(flat:data.searchResults[self.swipePosition + 4]) {
                        withAnimation {
                            self.swipeHandler(at: self.swipePosition + 4)
                        }
                    }.stacked(at: 4, in:5)
                }.frame(width: .infinity, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            } else {
                LoadingView().frame(width: .infinity, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            HStack {
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Dismiss")
                }.padding()
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Favor")
                }.padding()
            }
        }
        .padding()
    }
    
    func swipeHandler(at index: Int) {
        self.swipePosition += 1
    }
    
    func removeCard(at index: Int) {
        // Remove cards from Array
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView()
    }
}
