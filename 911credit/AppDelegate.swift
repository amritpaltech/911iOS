//
//  AppDelegate.swift
//  911credit
//
//  Created by iChirag on 28/06/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fcmToken: String?
    var notificationLaunchOption: [String: AnyObject]?
    var restrictRotation = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2)
        
        if Utils.getUserInfo()?.id == nil {
            setLoginScreen()
        } else {
            if Utils.getUserInfo()?.issecurityquestions == 1 {
                AppDelegate.shared?.setupSecurityQuestion()
            } else {
                AppDelegate.shared?.setupTabbar()
            }
        }
        //        setupStoryBoard(storyboard: Storyboard.authentication)
        navigationAppreance()
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (grantet, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject] {
            self.notificationLaunchOption = notification
            startNotification()
        } else {
            self.notificationLaunchOption = nil
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let userInfotDict = userInfo as? [String : AnyObject] {
            
            self.notificationLaunchOption = userInfotDict
            startNotification()
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completion: @escaping (UIBackgroundFetchResult) -> Void) {
        
        /*if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo",userInfo)*/
        completion(UIBackgroundFetchResult.newData)
    }
    
    // [END receive_message]
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if !self.restrictRotation {
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    func navigationAppreance() {
        
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = .getWhiteColor()
        appearance.isTranslucent = true

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratMedium(size: 24)]
 
        // Back button Arrow
        let back = UIImage(named: "backBlack")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0))
        appearance.backIndicatorImage = back
        appearance.backIndicatorTransitionMaskImage = back
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -5), for: UIBarMetrics.default)
    }
}

extension AppDelegate {
    // MARK: - AppDelegate Instance
    class var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func setupLogin() {
        let storyboard = UIStoryboard(name: Storyboard.authentication, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func setupSecurityQuestion() {
        let storyboard = UIStoryboard(name: "Security", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() ?? UIViewController()
        let nav = UINavigationController.init(rootViewController: controller)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func setupTabbar() {
        let storyboard = UIStoryboard(name: Storyboard.main, bundle: nil)
        if let viewcontroller = storyboard.instantiateInitialViewController() as? UITabBarController {
            viewcontroller.selectedIndex = 0
            self.window?.rootViewController = viewcontroller
            self.window?.makeKeyAndVisible()
        }
    }
    
    func setLoginScreen() {
        if Utils.getUserInfo() == nil {
            setupLogin()
        } else {
            setupTabbar()
        }
    }
    
    func startNotification() {
        
        
        print("Notification start.")
        if let notification = notificationLaunchOption {

            print("Notification Entered.......")
            //let notifications = notification["notification"]!
            
            if let isPopup = notification["is_pop_up"] as? Int, isPopup == 1 {
                
                if let popupData = notification["pop_up_data"] as? [String: AnyObject] {
                    
                    let message = popupData["message"] as? String
                    let title = popupData["title"] as? String
                    Utils.alert(message: message!, title: title)
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("\(notification.request.content.userInfo)")
        
        completionHandler([.alert, .badge, .sound])
    }
}

extension AppDelegate: MessagingDelegate {
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        self.fcmToken = fcmToken
        //let dataDict:[String: String] = ["token": fcmToken]
        
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
