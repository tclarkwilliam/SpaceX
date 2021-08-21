//
//  LinkOptionsViewController.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

import SafariServices

class LinkOptionsViewController: UIViewController {

  static let identifier = String(describing: LinkOptionsViewController.self)

  private let launchViewModel: LaunchViewModel

  init?(coder: NSCoder,
        launchViewModel: LaunchViewModel) {
    self.launchViewModel = launchViewModel
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @IBAction func articleButtonSelected() {
    presentSafariViewController(url: launchViewModel.articleURL)
  }

  @IBAction func wikipediaButtonSelected() {
    presentSafariViewController(url: launchViewModel.wikipediaURL)
  }

  @IBAction func videoButtonSelected() {
    presentSafariViewController(url: launchViewModel.videoURL)
  }

  private func presentSafariViewController(url: URL?) {
    guard let url = url else { return }
    present(SFSafariViewController(url: url), animated: true)
  }

}
