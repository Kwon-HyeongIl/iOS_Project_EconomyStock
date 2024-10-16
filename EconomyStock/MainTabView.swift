//
//  MainTabView.swift
//  EconomyStock
//
//  Created by 권형일 on 10/1/24.
//

import SwiftUI

struct MainTabView: View {
    @Environment(MainTabCapsule.self) var mainTabCapsule
    
    // 뷰 캐싱
    @State private var homeView = HomeView()
    @State private var courseListView = CourseListView()
    @State private var newsView = NewsView()
    @State private var profileView = ProfileView()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        @Bindable var mainTabCapsule = mainTabCapsule
        
        VStack {
            ZStack {
                switch mainTabCapsule.selectedTab {
                case .house:
                    homeView
                    
                case .textBookClosed:
                    courseListView
                    
                case .newspaper:
                    newsView
                    
                case .person:
                    profileView
                }
                
                VStack {
                    Spacer()
                    
                    MainCustomTabView()
                        .offset(y: 95)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(MainTabCapsule())
}
