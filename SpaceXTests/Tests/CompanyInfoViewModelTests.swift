//
//  CompanyInfoViewModelTests.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import XCTest

@testable import SpaceX

class CompanyInfoViewModelTests: XCTestCase {

  private var subject: CompanyInfoViewModel!

  override func setUp() {
    super.setUp()
    subject = CompanyInfoViewModel(companyInfo: .arrange())
  }

  override func tearDown() {
    subject = nil
    super.tearDown()
  }

  func test_name_returnsName() {
    XCTAssertEqual(subject.name, "Name")
  }

  func test_founder_returnsFounder() {
    XCTAssertEqual(subject.founder, "Founder")
  }

  func test_founded_returnsFounded() {
    XCTAssertEqual(subject.founded, 1900)
  }

  func test_employees_returnsEmployees() {
    XCTAssertEqual(subject.employees, 100)
  }

  func test_formattedValuation_returnsFormattedValuation() {
    XCTAssertEqual(subject.formattedValuation, "USD 100,000,000.00")
  }

  func test_launchSites_returnsLaunchSites() {
    XCTAssertEqual(subject.launchSites, 3)
  }

}
