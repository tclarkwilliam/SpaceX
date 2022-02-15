//
//  Links+Arrange.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import Foundation

@testable import SpaceX

extension Links {
  static func arrange() -> Links {
    .init(patch: Patch(small: "image/path"),
          article: "article/path",
          wikipedia: "wikipedia/path",
          video: "video/path")
  }
}
