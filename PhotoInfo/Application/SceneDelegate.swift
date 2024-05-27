//
//  SceneDelegate.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 23.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let imageLoader = ImageLoader()
        let infoPresenter = InfoPresenter(imageLoader: imageLoader)
        let infoViewController = InfoViewController(presenter: infoPresenter)
        infoPresenter.view = infoViewController

        window?.rootViewController = UINavigationController(rootViewController: infoViewController)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .tertiarySystemGroupedBackground
    }
}
