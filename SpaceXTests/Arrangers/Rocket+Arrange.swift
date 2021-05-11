//
//  Rocket+Arrange.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import Foundation

@testable import SpaceX

extension Rocket {
  static func arrange() -> Rocket {
    .init(name: "Rocket",
          type: "Type")
  }
}
