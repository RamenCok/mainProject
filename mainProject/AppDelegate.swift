//
//  AppDelegate.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import GoogleSignIn
import Firebase
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var launchURL :URL? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
//        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "fitze.page.link"
        
//        GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
        
        let navigation = UINavigationController()
        navigation.navigationBar.topItem?.backButtonDisplayMode = .minimal
        UINavigationBar.appearance().barTintColor = UIColor.navBar
        print("Yay")
        
       
        
//        if let userActDic = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [String: Any],let auserActivity  = userActDic["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity{
//
//                NSLog("type \(userActDic.self),\(userActDic)") // using NSLog for logging as print did not log to my 'Device and Simulator' logs
//                launchURL = auserActivity.webpageURL
//        }
//
        return true
    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("Masuk sini")
//        if let url = self.launchURL {
//            print("There is an url \(url)")
//            self.launchURL = nil
//            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
//                guard error == nil else {
//                    print("error: \(error?.localizedDescription)")
//                    return
//                }
//
//                if let dynamicLink = dynamicLink {
//                    self.handleDynamicLink(dynamicLink)
//                }
//
//            }
//
//        }
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received \(url.absoluteString)")
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//            self.handleDynamicLink(dynamicLink)
//            return true
//        } else {
//            print("Woy")
//            return GIDSignIn.sharedInstance.handle(url)
//        }
        print("Eloo")
        return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey
            .sourceApplication] as? String, annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        print("Dynamic Link: \(dynamicLink)")
        return true
      }
      return false
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        print("Handle")
        guard let url = dynamicLink.url else {
            print("error")
            return
        }
        print("Your incoming parameter is: \(url.absoluteString)")
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("Hello")
        if let linkURL = userActivity.webpageURL {
            print("Incoming URL: \(linkURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(linkURL) { dynamicLink, error in
                guard error == nil else {
                    print("error: \(error?.localizedDescription)")
                    return
                }
                
                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink)
                }
                
            }
            if linkHandled {
                return true
            } else {
                return false
            }
        }
        print("userActivity = nil")
        return false
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

