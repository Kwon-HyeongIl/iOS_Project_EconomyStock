//
//  User.swift
//  EconomyStock
//
//  Created by 권형일 on 10/2/24.
//

import Foundation
import FirebaseAuth

struct User: Codable, Identifiable, Hashable, Equatable {
    let id: String
    var deviceToken: String
    let username: String
    
    var authEmail: String
    
    var appleHashedUid: String?
    var googleHashedUid: String?
    var kakaoHashedUid: String?
    
    var contactEmail: String?
    var profileImageUrl: String?
    
    var isNotificationBadge: Bool?
    var notificationType: [NotificationType]
    
    var studyingPercentage: Double
}

extension User {
    static var DUMMY_USER: User = User(id: UUID().uuidString, deviceToken: "test", username: "행이", authEmail: "test@naver.com", notificationType: [.empty], studyingPercentage: 0.0)
}
