//
//  LaunchesServiceTests.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import XCTest

@testable import SpaceX

class LaunchesServiceTests: XCTestCase {

  private var mockService: MockService!

  override func setUp() {
    super.setUp()
    mockService = MockService()
  }

  override func tearDown() {
    mockService = nil
    super.tearDown()
  }

  func test_fetchLaunches_success_returnsLaunches() {
    let expectation = expectation(description: "Fetch launches success")
    let launches = launchesDictionary(isValidData: true)
    mockService.data = try? JSONSerialization.data(withJSONObject: [launches], options: [])
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .success(let launches) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(launches)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchLaunches_failure_returnsError() {
    let expectation = expectation(description: "Fetch launches failure")
    let launches = launchesDictionary(isValidData: false)
    mockService.data = try? JSONSerialization.data(withJSONObject: [launches], options: [])
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .decoding)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchLaunches_invalidData_returnsError() {
    let expectation = expectation(description: "Fetch launches invalid data")
    mockService.data = nil
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidData)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  private func launchesDictionary(isValidData: Bool) -> [String: Any] {
    let patch = ["small": "url.png"]
    let linksDictionary = ["patch": patch]
    return ["name": isValidData ? "Name" : 1,
            "date_local": "2020-10-24T11:31:00-04:00",
            "success": true,
            "links": linksDictionary]
  }
}
