//
//  SceneDelegate.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 03/05/2021.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    var userDefaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if defaults.bool(forKey: "WatchWalkThrough") == true {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            self.window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootVC.navigationController?.navigationBar.isHidden = true
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
            UIApplication.shared.registerForRemoteNotifications()
            center.delegate = self
            center.requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                
            }
            setupNotification()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func setupNotification(){
        /**
         Fetch random quote from local db
         save it to an obj
         */
        let content = UNMutableNotificationContent()
        content.title = "Today's Quote"
        content.body = "Tap to see your today's quotation."
        content.sound = UNNotificationSound.default
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 30
        let ri = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: ri)
        center.add(request)
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

