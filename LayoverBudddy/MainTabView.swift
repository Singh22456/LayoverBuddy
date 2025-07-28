//
//  MainTabView.swift
//  LayoverBudddy
//
//  Created by Brahmjot Singh Tatla on 28/07/25.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        // Set Tab Bar background to white
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white

        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        // For iOS 15+
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            Text("Explore View")
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
        }
    }
}

#Preview {
    MainTabView()
}
