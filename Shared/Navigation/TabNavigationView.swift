//
//  TabNavigationView.swift
//  ManaGuide (iOS)
//
//  Created by Vito Royeca on 4/24/22.
//

import SwiftUI
import ManaKit

struct TabNavigationView: View {
    enum TabItem {
        case news
        case sets
        case cards
    }
    
    @State private var selection: TabItem = .news
    private let keyruneUnicode = "e615" // Legends
    
    var body: some View {
        TabView(selection: $selection) {
//            NavigationView {
//                NewsView()
//            }
//                .navigationViewStyle(.stack)
//                .tabItem {
//                    Image(systemName: "newspaper")
//                    Text("News")
//                }
//                .tag(TabItem.news)

            SetsView()
                .navigationViewStyle(.stack)
                .tabItem {
                    Image(systemName: "rectangle.3.group")
                    Text("Sets")
                }
                .tag(TabItem.sets)

            CardsSearchFormView()
                .navigationViewStyle(.stack)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabItem.cards)
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
