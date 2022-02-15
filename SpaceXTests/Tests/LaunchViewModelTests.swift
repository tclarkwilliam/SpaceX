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

  func test_launchDate_returnsLaunchDate() {
    XCTAssertEqual(subject.launchDate, "1 January 1970 at 01:00:00 GMT+1")
  }

  func test_isLaunchSuccessful_returnsIsLaunchSuccessful() {
    XCTAssertTrue(subject.isLaunchSuccessful)
  }

  func test_launchImage_successfulLaunch_returnsCheckmarkImage() {
    XCTAssertEqual(subject.launchImage, UIImage(systemName: "checkmark"))
  }

  func test_launchImage_unsuccessfulLaunch_returnsXmarkImage() {
    subject = LaunchViewModel(launch: .arrange(launchSuccess: false))
    XCTAssertEqual(subject.launchImage, UIImage(systemName: "xmark"))
  }

  func test_launchImageTintColour_successfulLaunch_returnsGreen() {
    XCTAssertEqual(subject.launchImageTintColour, .systemGreen)
  }

  func test_launchImageTintColour_unsuccessfulLaunch_returnsRed() {
    subject = LaunchViewModel(launch: .arrange(launchSuccess: false))
    XCTAssertEqual(subject.launchImageTintColour, .systemRed)
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

  func test_missionImagePath_returnsMissionImagePath() {
    XCTAssertEqual(subject.missionImagePath, "image/path")
  }

  func test_articleURL_returnsArticleURL() {
    XCTAssertEqual(subject.articleURL, URL(string: "article/path"))
  }

  func test_wikipediaURL_returnsWikipediaURL() {
    XCTAssertEqual(subject.wikipediaURL, URL(string: "wikipedia/path"))
  }

  func test_videoURL_returnsVideoURL() {
    XCTAssertEqual(subject.videoURL, URL(string: "video/path"))
  }

  func test_launchYear_returnsLaunchYear() {
    XCTAssertEqual(subject.launchYear, 1970)
  }

}
