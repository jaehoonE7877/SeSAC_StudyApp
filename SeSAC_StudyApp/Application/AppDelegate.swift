//
//  AppDelegate.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    private let sesacAPIService = DefaultSeSACAPIService.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkCheck.shared.startMonitoring()
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                UserManager.fcmToken = token
//                print("FCM registration token: \(token)")
//            }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
    }
    
}

extension AppDelegate: MessagingDelegate {
    // 토큰 갱신(Refresh Token)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDictonary: [String: String] = ["token": fcmToken ?? ""]
        guard let fcmToken = fcmToken else { return }
        UserManager.fcmToken =  fcmToken
//        updateFCM(fcmToken: fcmToken) { statusCode in
//            switch SeSACError(rawValue: statusCode) {
//            case .success:
//                UserManager.fcmToken =  fcmToken
//            default:
//                print(statusCode)
//            }
//        }
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDictonary)
    }
    
}

extension AppDelegate {
    
    private func updateFCM(fcmToken: String, completion: @escaping (Int) -> Void) {
        sesacAPIService.requestSeSACAPI(router: .updateFCM(fcmToken: fcmToken)) { statusCode in
            switch SeSACError(rawValue: statusCode) {
            case .success:
                completion(statusCode)
            default:
                completion(statusCode)
            }
        }
    }
}

