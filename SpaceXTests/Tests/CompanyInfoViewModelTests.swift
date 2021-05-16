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

  func test_statement_returnsFormattedIntro() {
    let statement = "Name was founded by Founder in 1900. It has now 100 employees, 3 launch sites, and is valued at USD 100,000,000.00"
    XCTAssertEqual(subject.statement, statement)
  }

}
