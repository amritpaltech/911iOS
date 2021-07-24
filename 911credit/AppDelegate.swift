//
//  AppDelegate.swift
//  911credit
//
//  Created by iChirag on 28/06/21.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
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
        return true
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
}
