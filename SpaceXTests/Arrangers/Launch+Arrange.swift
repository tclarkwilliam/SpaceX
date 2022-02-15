//
//  Launch+Arrange.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import Foundation

@testable import SpaceX

extension Launch {
  static func arrange(launchDate: Date = .init(timeIntervalSince1970: .zero),
                      launchSuccess: Bool = true) -> Launch {
    .init(missionName: "Mission",
          date: launchDate,
          launchSuccess: launchSuccess,
          links: .arrange())
  }
}
