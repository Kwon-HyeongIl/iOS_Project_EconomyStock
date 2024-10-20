//
//  NavigationStackView.swift
//  EconomyStock
//
//  Created by 권형일 on 10/1/24.
//

import Foundation

enum NavigationStackPath: Hashable {
    // Auth
    case BasicLoginView
    case BasicSignupView
    case FindPasswordView
    case AccountSupportView
    
    // Studying
    case CourseIntroView(CourseViewModel)
    
    case BasicEconomy1View(CourseViewModel)
    
    case PriceLevel1View(CourseViewModel)
}
