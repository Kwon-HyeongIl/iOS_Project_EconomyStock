//
//  EconomyStockApp.swift
//  EconomyStock
//
//  Created by 권형일 on 9/30/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseMessaging
import GoogleSignIn
import GoogleMobileAds

@main
struct EconomyStockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    
    init() {
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationBaseView()
                .onOpenURL { url in
                    // 카카오 로그인 URL 처리
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    // 구글 로그인 URL 처리
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(for: LocalUser.self, isAutosaveEnabled: true)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func refreshDeviceToken() {
        Messaging.messaging().deleteToken { error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            // 새 토큰 요청
            Messaging.messaging().token { token, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if let token {
                    FCMManager.shared.myDeviceToken = token
                }
            }
        }
    }
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        print("token:", dataDict["token"] ?? "")
        
        FCMManager.shared.myDeviceToken = dataDict["token"] ?? ""
    }
}

// 메세지 수신
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 푸시 메세지가 앱이 켜져있는 동안 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 알림을 클릭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        completionHandler()
    }
}

