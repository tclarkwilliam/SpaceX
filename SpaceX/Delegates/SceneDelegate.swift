//
//  SceneDelegate.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    let isRunningTests = NSClassFromString("XCTestCase") != nil
    if isRunningTests {
      window = nil
    }
  }
  
}
