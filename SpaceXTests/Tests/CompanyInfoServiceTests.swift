//
//  CompanyInfoServiceTests.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import XCTest

@testable import SpaceX

class CompanyInfoServiceTests: XCTestCase {

  private var mockService: MockService!

  override func setUp() {
    super.setUp()
    mockService = MockService()
  }

  override func tearDown() {
    mockService = nil
    super.tearDown()
  }

  func test_fetchInfo_success_returnsCompanyInfo() {
    let expectation = expectation(description: "Fetch info success")
    let companyInfo = companyInfoDictionary(isValidData: true)
    mockService.data = try? JSONSerialization.data(withJSONObject: companyInfo, options: [])
    let subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .success(let companyInfo) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(companyInfo)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchInfo_failure_returnsError() {
    let expectation = expectation(description: "Fetch info failure")
    let companyInfo = companyInfoDictionary(isValidData: false)
    mockService.data = try? JSONSerialization.data(withJSONObject: companyInfo, options: [])
    let subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .decoding)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchInfo_invalidData_returnsError() {
    let expectation = expectation(description: "Fetch info invalid data")
    mockService.data = nil
    let subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidData)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  private func companyInfoDictionary(isValidData: Bool) -> [String: Any] {
    ["name": "Name",
     "founder": "Founder",
     "founded": 1,
     "employees": 1,
     "valuation": 1,
     "launch_sites": isValidData ? 1 : "1"]
  }

}
