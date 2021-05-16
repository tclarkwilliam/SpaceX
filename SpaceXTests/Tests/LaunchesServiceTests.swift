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
    let launches = launchesDictionary(isValidData: true)
    mockService.data = try? JSONSerialization.data(withJSONObject: [launches], options: [])
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .success(let launches) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(launches)
    }
  }

  func test_fetchLaunches_failure_returnsError() {
    let launches = launchesDictionary(isValidData: false)
    mockService.data = try? JSONSerialization.data(withJSONObject: [launches], options: [])
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
  }

  func test_fetchLaunches_invalidData_returnsError() {
    mockService.data = nil
    let subject = LaunchesService(service: mockService)
    subject.fetchLaunches { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
  }

  private func launchesDictionary(isValidData: Bool) -> [String: Any] {
    let rocketDictionary = ["rocket_name": "Name",
                            "rocket_type": "Type"]
    let linksDictionary = ["mission_patch_small": "url.png"]
    return ["mission_name": isValidData ? "Name" : 1,
            "rocket": rocketDictionary,
            "launch_date_local": "2020-10-24T11:31:00-04:00",
            "launch_success": true,
            "links": linksDictionary]
  }
}
