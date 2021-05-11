//
//  CompanySectionTests.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import XCTest

@testable import SpaceX

class CompanySectionTests: XCTestCase {

  private var subject: CompanySection!

  override func setUp() {
    super.setUp()
    let companyInfoViewModel = CompanyInfoViewModel(companyInfo: .arrange())
    subject = CompanySection(companyInfoViewModel: companyInfoViewModel)
  }

  override func tearDown() {
    subject = nil
    super.tearDown()
  }

  func test_title_returnsCorrectTitle() {
    XCTAssertEqual(subject.title, "COMPANY")
  }

  func test_numberOfRows_returnsCorrectNumberOfRows() {
    XCTAssertEqual(subject.numberOfRows, 1)
  }

}
