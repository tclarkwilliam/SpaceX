//
//  LinkOptionsViewController.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

import SafariServices

class LinkOptionsViewController: UIViewController {

  static let identifier = String(describing: LinkOptionsViewController.self)

  var launchViewModel: LaunchViewModel?

  @IBAction func articleButtonSelected() {
    presentSafariViewController(url: launchViewModel?.articleURL)
  }

  @IBAction func wikipediaButtonSelected() {
    presentSafariViewController(url: launchViewModel?.wikipediaURL)
  }

  @IBAction func videoButtonSelected() {
    presentSafariViewController(url: launchViewModel?.videoURL)
  }

  private func presentSafariViewController(url: URL?) {
    guard let url = url else { return }
    present(SFSafariViewController(url: url), animated: true)
  }

}
