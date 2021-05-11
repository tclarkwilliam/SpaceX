//
//  CompanyInfoServiceTests.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import XCTest

@testable import SpaceX

class CompanyInfoServiceTests: XCTestCase {

  private var subject: CompanyInfoService!
  private var mockService: MockService!

  override func setUp() {
    super.setUp()
    mockService = MockService()
  }

  override func tearDown() {
    mockService = nil
    subject = nil
    super.tearDown()
  }

  func test_fetchInfo_success_returnsCompanyInfo() {
    let companyInfo = companyInfoDictionary(isValidData: true)
    mockService.data = try? JSONSerialization.data(withJSONObject: companyInfo, options: [])
    subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .success(let companyInfo) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(companyInfo)
    }
  }

  func test_fetchInfo_failure_returnsError() {
    let companyInfo = companyInfoDictionary(isValidData: false)
    mockService.data = try? JSONSerialization.data(withJSONObject: companyInfo, options: [])
    subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
  }

  func test_fetchInfo_invalidData_returnsError() {
    mockService.data = nil
    subject = CompanyInfoService(service: mockService)
    subject.fetchInfo { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
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
