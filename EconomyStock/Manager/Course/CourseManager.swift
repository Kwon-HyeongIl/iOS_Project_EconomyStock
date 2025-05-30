//
//  CourseManager.swift
//  EconomyStock
//
//  Created by 권형일 on 12/10/24.
//

import Foundation
import FirebaseFirestore

class CourseManager {
    static func updateUserCourseParmanentProgressPage(type: CourseAndNewsType, parmanentProgressPage: Int) async {
        var editedData: [String: Any] = [:]
        
        let courseTypeParmanentProgressPage: String
        
        switch type {
            
        case .basicEconomy:
            courseTypeParmanentProgressPage = "basicEconomyParmanentProgressPage"
        case .priceLevel:
            courseTypeParmanentProgressPage = "priceLevelParmanentProgressPage"
        case .unEmployment:
            courseTypeParmanentProgressPage = "unEmploymentParmanentProgressPage"
        case .moneyAndFinance:
            courseTypeParmanentProgressPage = "moneyAndFinanceParmanentProgressPage"
        case .exchangeRateAndBalanceOfPayment:
            courseTypeParmanentProgressPage = "exchangeRateAndBalanceOfPaymentParmanentProgressPage"
        }
        
        editedData["studyingCourse.\(courseTypeParmanentProgressPage)"] = parmanentProgressPage
        
        guard let userId = AuthManager.shared.remoteUser?.id else { return }
        
        do {
            try await Firestore.firestore()
                .collection("User").document(userId)
                .updateData(editedData)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func updateUserCourseLastPage(type: CourseAndNewsType, lastPage: Int) async {
        var editedData: [String: Any] = [:]
        
        let courseTypeLastPage: String
        
        switch type {
            
        case .basicEconomy:
            courseTypeLastPage = "basicEconomyLastPage"
        case .priceLevel:
            courseTypeLastPage = "priceLevelLastPage"
        case .unEmployment:
            courseTypeLastPage = "unEmploymentLastPage"
        case .moneyAndFinance:
            courseTypeLastPage = "moneyAndFinanceLastPage"
        case .exchangeRateAndBalanceOfPayment:
            courseTypeLastPage = "exchangeRateAndBalanceOfPaymentLastPage"
        }
        
        editedData["studyingCourse.\(courseTypeLastPage)"] = lastPage
        
        guard let userId = AuthManager.shared.remoteUser?.id else { return }
        
        do {
            try await Firestore.firestore()
                .collection("User").document(userId)
                .updateData(editedData)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
