//
//  CompanyInfo+Arrange.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import Foundation

@testable import SpaceX

extension CompanyInfo {
  static func arrange() -> CompanyInfo {
    .init(name: "Name",
          founder: "Founder",
          founded: 1900,
          employees: 100,
          valuation: 100000000,
          launchSites: 3)
  }
}
