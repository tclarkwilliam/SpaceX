//
//  LaunchesStateView.swift
//  SpaceX
//
//  Created by Tom on 20/08/2021.
//

import SwiftUI

class LaunchesStateView: UIView {

  enum State {
    case loading
    case error(ServiceError)
  }

  func configure(_ state: State) {
    switch state {
    case .loading:
      show(AnyView(LaunchesLoadingView()))
    case .error(let error):
      show(AnyView(LaunchesErrorView(error: error)))
    }
  }

  private func show(_ view: AnyView) {
    let hostingController = UIHostingController(rootView: view)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hostingController.view)
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

}
