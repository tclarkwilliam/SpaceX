//
//  LaunchViewModelTests.swift
//  SpaceXTests
//
//  Created by Tom on 06/05/2021.
//

import XCTest

@testable import SpaceX

class LaunchViewModelTests: XCTestCase {

  private var subject: LaunchViewModel!

  override func setUp() {
    super.setUp()
    subject = LaunchViewModel(launch: .arrange())
  }

  override func tearDown() {
    subject = nil
    super.tearDown()
  }

  func test_missionName_returnsName() {
    XCTAssertEqual(subject.missionName, "Mission")
  }

  func test_formattedRocket_returnsFormattedRocket() {
    XCTAssertEqual(subject.formattedRocket, "Rocket / Type")
  }

  func test_launchDate_returnsLaunchDate() {
    XCTAssertEqual(subject.launchDate, "January 1, 1970 at 1:00:00 AM GMT+1")
  }

  func test_isLaunchSuccessfull_returnsIsLaunchSuccessfull() {
    XCTAssertTrue(subject.isLaunchSuccessfull)
  }

  func test_launchImage_successfullLaunch_returnsCheckmarkImage() {
    XCTAssertEqual(subject.launchImage, UIImage(systemName: "checkmark"))
  }

  func test_launchImage_unsuccessfullLaunch_returnsXmarkImage() {
    subject = LaunchViewModel(launch: .arrange(launchSuccess: false))
    XCTAssertEqual(subject.launchImage, UIImage(systemName: "xmark"))
  }

  func test_launchImageTintColour_successfullLaunch_returnsGreen() {
    XCTAssertEqual(subject.launchImageTintColour, .green)
  }

  func test_launchImageTintColour_unsuccessfullLaunch_returnsRed() {
    subject = LaunchViewModel(launch: .arrange(launchSuccess: false))
    XCTAssertEqual(subject.launchImageTintColour, .red)
  }

  func test_launchDateDaysPrefix_past_returnsSince() {
    XCTAssertEqual(subject.launchDateDaysPrefix, "Days since now:")
  }

  func test_launchDateDaysPrefix_future_returnsFrom() {
    subject = LaunchViewModel(launch: .arrange(launchDate: .init(timeIntervalSinceNow: 1)))
    XCTAssertEqual(subject.launchDateDaysPrefix, "Days from now:")
  }

  func test_launchDateDays_returnsLaunchDateDays() {
    let oneDayInSeconds: TimeInterval = 86400
    XCTAssertEqual(subject.launchDateDays(date: .init(timeIntervalSince1970: oneDayInSeconds)), "1")
  }

}
