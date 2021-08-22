//
//  FilterLaunchesViewControllerTests.swift
//  SpaceXUITests
//
//  Created by Tom on 21/08/2021.
//

import XCTest

@testable import SpaceX

class FilterLaunchesViewControllerTests: XCTestCase {

  var app: XCUIApplication!

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["UITests"]
    app.launch()
    app.navigationBars.firstMatch.buttons["FilterButton"].tap()
  }

  override func tearDown() {
    app.launchArguments = []
    app = nil
    super.tearDown()
  }

  func test_launchOutcome_selectSameCell_isSelectedTrue() throws {
    let successCell = cell(identifier: Constants.successCellIdentifier)
    successCell.tap()
    XCTAssertTrue(successCell.isSelected)
  }

  func test_launchOutcome_selectSameCellTwice_isSelectedFalse() throws {
    let successCell = cell(identifier: Constants.successCellIdentifier)
    successCell.tap()
    successCell.tap()
    XCTAssertFalse(successCell.isSelected)
  }

  func test_launchOutcome_selectSuccessThenFailure_successSelectedFalseAndFailureSelectedTrue() throws {
    let successCell = cell(identifier: Constants.successCellIdentifier)
    let failureCell = cell(identifier: Constants.failureCellIdentifier)
    successCell.tap()
    failureCell.tap()
    XCTAssertFalse(successCell.isSelected)
    XCTAssertTrue(failureCell.isSelected)
  }

  func test_launchYears_selectSameCell_isSelectedTrue() throws {
    let yearCell = cell(identifier: Constants.year2006CellIdentifier)
    yearCell.tap()
    XCTAssertTrue(yearCell.isSelected)
  }

  func test_launchYears_selectSameCellTwice_isSelectedFalse() throws {
    let yearCell = cell(identifier: Constants.year2006CellIdentifier)
    yearCell.tap()
    yearCell.tap()
    XCTAssertFalse(yearCell.isSelected)
  }

  func test_launchYears_select2006Then2008_2006SelectedTrueAnd2008SelectedTrue() throws {
    let yearCell2006 = cell(identifier: Constants.year2006CellIdentifier)
    let yearCell2008 = cell(identifier: Constants.year2008CellIdentifier)
    yearCell2006.tap()
    yearCell2008.tap()
    XCTAssertTrue(yearCell2006.isSelected)
    XCTAssertTrue(yearCell2008.isSelected)
  }

  func test_sortOrder_selectSameCell_isSelectedTrue() throws {
    let ascendingCell = cell(identifier: Constants.ascendingCellIdentifier)
    ascendingCell.tap()
    XCTAssertTrue(ascendingCell.isSelected)
  }

  func test_sortOrder_selectSameCellTwice_isSelectedFalse() throws {
    let ascendingCell = cell(identifier: Constants.ascendingCellIdentifier)
    ascendingCell.tap()
    ascendingCell.tap()
    XCTAssertFalse(ascendingCell.isSelected)
  }

  func test_sortOrder_selectAscendingThenDescending_ascendingSelectedFalseAndDescendingSelectedTrue() throws {
    let ascendingCell = cell(identifier: Constants.ascendingCellIdentifier)
    let descendingCell = cell(identifier: Constants.descendingCellIdentifier)
    ascendingCell.tap()
    descendingCell.tap()
    XCTAssertFalse(ascendingCell.isSelected)
    XCTAssertTrue(descendingCell.isSelected)
  }

  func test_multiSectionSelection_selectSuccessThen2006ThenDescending_allSelectedTrue() throws {
    let successCell = cell(identifier: Constants.successCellIdentifier)
    let yearCell2006 = cell(identifier: Constants.year2006CellIdentifier)
    let descendingCell = cell(identifier: Constants.descendingCellIdentifier)
    successCell.tap()
    yearCell2006.tap()
    descendingCell.tap()
    XCTAssertTrue(successCell.isSelected)
    XCTAssertTrue(yearCell2006.isSelected)
    XCTAssertTrue(descendingCell.isSelected)
  }

  func cell(identifier: String) -> XCUIElement {
    app.tables
      .containing(.table, identifier: "FilterTableView")
      .cells
      .element(matching: .cell, identifier: identifier)

  }

}

extension FilterLaunchesViewControllerTests {
  struct Constants {
    static let filterButtonIdentifier = "FilterButton"
    static let successCellIdentifier = "Success"
    static let failureCellIdentifier = "Failure"
    static let ascendingCellIdentifier = "Ascending"
    static let descendingCellIdentifier = "Descending"
    static let year2006CellIdentifier = "2006"
    static let year2008CellIdentifier = "2008"
  }
}
