//
//  CustomTabView.swift
//  Albedo
//
//  Created by Simon Müller on 08.12.20.
//

import SwiftUI


struct TabBar: View {
    @ObservedObject var tabItems: TabItems
    let padding: CGFloat = 5
    let iconeSize: CGFloat = 20
    var iconFrame: CGFloat {
        (padding * 2) + iconeSize
    }
    var tabItemCount: CGFloat {
        CGFloat(tabItems.items.count)
    }
    var spacing: CGFloat {
        (UIScreen.main.bounds.width - (iconFrame * tabItemCount)) / (tabItemCount * 2)
    }
    var body: some View {
        VStack {
            Spacer()
                ZStack {
                    Bar(tabItems: tabItems)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 80)
                    HStack(spacing: spacing) {
                        ForEach(0..<tabItems.items.count, id: \.self) { i in
                            VStack {
                                Image(self.tabItems.items[i].imageName)
                                    .resizable()
                                    .foregroundColor(Color.gray)
                                    .frame(width: self.iconeSize, height: self.iconeSize)
                                    .opacity(self.tabItems.items[i].opacity)
                                    .padding(.all, padding)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        withAnimation(Animation.easeInOut) {
                                            self.tabItems.select(i)
                                        }
                                    }
                                Text(self.tabItems.items[i].name).foregroundColor(Color("Grey")).font(.custom("DMSans-Regular", size: 15))
                            }
                            .offset(y: self.tabItems.items[i].offset)
                            .frame(width: 80)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                .offset(y: 35.0)
        }
    }
}


struct Bar: Shape {
    @ObservedObject var tabItems: TabItems
    
    init(tabItems: TabItems) {
        self.tabItems = tabItems
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
    }
}

class TabItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    var offset: CGFloat = -10
    var opacity: Double = 1
    
    init(imageName: String, offset: CGFloat, name: String) {
        self.imageName = imageName
        self.offset = offset
        self.name = name
    }
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
}

class TabItems: ObservableObject {

    @Published var items: [TabItem] = [
        TabItem(imageName: "dating", name: "WG-Match"),
        TabItem(imageName: "suche", offset: -25, name: "Suche"),
        TabItem(imageName: "profil", name: "Profil"),
    ]
    
    @Published var selectedTabIndex: CGFloat = 2
    
    func select(_ index: Int) {
        let tabItem = items[index]
        
        tabItem.opacity = 0
        tabItem.offset = 10
        
        withAnimation(Animation.easeInOut) {
            selectedTabIndex = CGFloat(index + 1)
            for i in 0..<items.count {
                if i != index {
                    items[i].offset = -10
                }
            }
        }
        withAnimation(Animation.easeOut(duration: 0.25).delay(0.25)) {
            tabItem.opacity = 1
            tabItem.offset = -25
        }
    }
}

