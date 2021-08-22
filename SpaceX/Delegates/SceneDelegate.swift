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
    let isRunningUnitTests = NSClassFromString("XCTestCase") != nil
    let isRunningUITests = CommandLine.arguments.contains("UITests")
    if isRunningUnitTests {
      window = nil
    } else if isRunningUITests {
      UIView.setAnimationsEnabled(false)
    }
  }
  
}
