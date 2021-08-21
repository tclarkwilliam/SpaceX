//
//  ActivityViewController.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

import UIKit

class ActivityViewController: UIActivityViewController {

  private let childViewController: UIViewController

  init(childViewController: UIViewController) {
    self.childViewController = childViewController
    super.init(activityItems: [], applicationActivities: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(childViewController)
    view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }

}
