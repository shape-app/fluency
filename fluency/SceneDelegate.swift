// Copyright (c) 2025-present Shape
// Licensed under the MIT License

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .systemBackground

        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
    }
}
