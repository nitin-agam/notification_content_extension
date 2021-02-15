//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Nitin A on 15/02/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupPushNotification()
        moveToInitialController()
        registerNotificationCategories()
        return true
    }
    
    private func moveToInitialController() {
        let viewController = HomeViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
    
    private func setupPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
                print("Notifications permission granted.")
            } else {
                print("Failed to Notifications permission with error: \(String(describing: error?.localizedDescription)).")
            }
        }
    }
    
    private func registerNotificationCategories() {
        let moreAction = UNNotificationAction( identifier: "watch.more",
                                               title: "Watch More",
                                               options: [.foreground])
        let shareVideoAction = UNNotificationAction( identifier: "share",
                                                     title: "Share",
                                                     options: [.foreground])
        let videoCategory = UNNotificationCategory( identifier: "news_video_notification",
                                                    actions: [moreAction, shareVideoAction],
                                                    intentIdentifiers: [],
                                                    options: [])
        UNUserNotificationCenter.current().setNotificationCategories([videoCategory])
    }
}

// MARK:- UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let data = response.notification.request.content.userInfo as? [String: Any] {
            print("Notification data: \(data) and action: \(response.actionIdentifier)")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner])
    }
}

