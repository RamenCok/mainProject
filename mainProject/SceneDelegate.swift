//
//  SceneDelegate.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//

import UIKit
import FirebaseAuth
import Firebase
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        print("Handle")
        guard let url = dynamicLink.url else {
            print("error")
            return
        }
        print("Your incoming parameter is: \(url.absoluteString)")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard (scene is UIWindowScene) else { return }
//
//        if let firstUrlContext = connectionOptions.userActivities.first,let url = firstUrlContext.webpageURL  {
//            print("There is an url \(url)")
//            DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamiclink, error) in
//                if let dynamiclink = dynamiclink {
//                    self.handleDynamicLink(dynamiclink)
//                }
//              }
//            }
        

        
        var vc: UIViewController = OnboardingViewController()

        if let user = Auth.auth().currentUser {
            print(user.uid)
            print(user.isAnonymous)
            if user.isAnonymous {
                vc = BrandCatalogueViewController()
            } else {
                vc = BrandCatalogueViewController()
            }
        } else {
            print("no user")
        }

        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        
        navigationController.pushViewController(vc, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        let networkConnect = NetworkConnection()
        networkConnect.checkConnection()
    }
    
   
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        // Hapus semua file di cache
        let docsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        if FileManager.default.fileExists(atPath: docsUrl.path) {
            do {
                print("DEBUG: Deleting files")
                try FileManager.default.removeItem(at: docsUrl)
            } catch {
                print("DEBUG: Cannot delete file")
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

