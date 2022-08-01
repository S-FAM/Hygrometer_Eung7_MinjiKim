//
//  SceneDelegate.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = EntryViewController()
//    window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
    window?.makeKeyAndVisible()
  }
}
