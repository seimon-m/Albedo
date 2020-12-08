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
        (UIScreen.main.bounds.width - (iconFrame * tabItemCount)) / (tabItemCount + 1)
    }
    var firstCenter: CGFloat {
         spacing + iconFrame/2
    }
    var stepperToNextCenter: CGFloat {
        spacing + iconFrame //half of 1 and half of next
    }
    var body: some View {
        VStack {
            Spacer()
                ZStack {
                    Bar(tabItems: tabItems,
                        firstCenter: firstCenter,
                        stepperToNextCenter: stepperToNextCenter)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 70)
                    HStack(spacing: spacing) {
                        ForEach(0..<tabItems.items.count, id: \.self) { i in
                            ZStack {
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
                                Text(self.tabItems.items[i].name).offset(y: 25.0).foregroundColor(Color("Grey")).font(.custom("DMSans-Regular", size: 15))
                            }
                            .offset(y: self.tabItems.items[i].offset)
                        }
            }
            .edgesIgnoringSafeArea(.all)
           }
        }
    }
}


struct Bar: Shape {
    @ObservedObject var tabItems: TabItems
    var tab: CGFloat
    let firstCenter: CGFloat
    let stepperToNextCenter: CGFloat
    
    init(tabItems: TabItems, firstCenter: CGFloat, stepperToNextCenter: CGFloat) {
        self.tabItems = tabItems
        self.tab = tabItems.selectedTabIndex
        self.firstCenter = firstCenter
        self.stepperToNextCenter = stepperToNextCenter
    }
    
    var animatableData: Double {
        get { return Double(tab) }
        set { tab = CGFloat(newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        let tabCenter = firstCenter + stepperToNextCenter * (tab - 1)
        return Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.addLine(to: CGPoint(x: tabCenter + 50, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX - tabCenter, y: rect.minY))
        }
    }
}

class TabItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    var offset: CGFloat = -20
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
        TabItem(imageName: "suche", offset: -35, name: "Suche"),
        TabItem(imageName: "profil", name: "Profil"),
    ]
    
    @Published var selectedTabIndex: CGFloat = 2
    
    func select(_ index: Int) {
        let tabItem = items[index]
        
        tabItem.opacity = 0
        tabItem.offset = 20
        
        withAnimation(Animation.easeInOut) {
            selectedTabIndex = CGFloat(index + 1)
            for i in 0..<items.count {
                if i != index {
                    items[i].offset = -20
                }
            }
        }
        withAnimation(Animation.easeOut(duration: 0.25).delay(0.25)) {
            tabItem.opacity = 1
            tabItem.offset = -35
        }
    }
}

