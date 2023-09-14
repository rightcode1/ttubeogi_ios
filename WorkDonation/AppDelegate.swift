//
//  AppDelegate.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/11/30.
//


import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Thread.sleep(forTimeInterval: 1.0)
    // Override point for customization after application launch.
    IQKeyboardManager.shared.enable = true
    // kakao
    KakaoSDK.initSDK(appKey: "6e97ddff0dc5e73da07d1c742fc69422")
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    
//     FCM
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
      UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) -> Void  in
        guard settings.authorizationStatus == UNAuthorizationStatus.authorized else {
          return;
        }

        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      })

      if let err = error {

      }
    }
    
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("!!!")
    if KakaoSDKAuth.AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    return false
  }


  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // 포어그라운드에서도 알림을 받을수 있게 만드는법
    // 딜리게이트. UNUserNotificationCenter.current().delegate = self  // 필수
    print("\(#function)")
    Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
    completionHandler([.alert, .badge, .sound])
  }
  
  
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(fcmToken)")
    let dataDict:[String: String] = ["token": fcmToken!]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    FcmToken = fcmToken!
    ApiService.request(router: NotificationApi.registNotificationToken(notificationToken: FcmToken), success: { (response: ApiResponse<DefaultResponse>) in
    }) { (error) in
    }
  }
  
}
