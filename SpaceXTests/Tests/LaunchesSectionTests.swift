//
//  LaunchesSectionTests.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import XCTest

@testable import SpaceX

class LaunchesSectionTests: XCTestCase {

  private var subject: LaunchesSection!

  override func setUp() {
    super.setUp()
    let viewModels = [
      LaunchViewModel(launch: .arrange()),
      LaunchViewModel(launch: .arrange()),
      LaunchViewModel(launch: .arrange())
    ]
    subject = LaunchesSection(launchViewModels: viewModels)
  }

  override func tearDown() {
    subject = nil
    super.tearDown()
  }

  func test_title_returnsCorrectTitle() {
    XCTAssertEqual(subject.title, "LAUNCHES")
  }

  func test_numberOfRows_returnsCorrectNumberOfRows() {
    XCTAssertEqual(subject.numberOfRows, 3)
  }

}
