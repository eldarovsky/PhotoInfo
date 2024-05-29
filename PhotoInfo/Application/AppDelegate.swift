//
//  AppDelegate.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 23.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import YandexMapsMobile

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        YMKMapKit.setApiKey("db29b8c4-7b13-4889-86b6-5878527cef78")
        YMKMapKit.sharedInstance()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
