//
//  LaunchesFilterApplicatorTests.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import XCTest

@testable import SpaceX

class LaunchesFilterApplicatorTests: XCTestCase {

  func test_apply_launchSuccess_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [successRow(.success)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 3)
  }

  func test_apply_launchSuccess_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [successRow(.success), yearRow(2016)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 2)
  }

  func test_apply_launchFailure_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [successRow(.failure), yearRow(2020)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 1)
  }

  func test_apply_sortOrder_ascending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [sortOrderRow(.ascending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 5)
    XCTAssertEqual(subject.filteredLaunches().first?.launchYear, 2006)
    XCTAssertEqual(subject.filteredLaunches().last?.launchYear, 2020)
  }

  func test_apply_sortOrder_descending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [sortOrderRow(.descending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 5)
    XCTAssertEqual(subject.filteredLaunches().first?.launchYear, 2020)
    XCTAssertEqual(subject.filteredLaunches().last?.launchYear, 2006)
  }

  func test_apply_launchSuccess_launchYear_sortOrder_returnsFilteredLaunches() {
    let rows = [
      successRow(.success),
      yearRow(2016),
      sortOrderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filteredRows: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 2)
  }

  func test_apply_launchSuccess_multipleLaunchYears_sortOrder_returnsFilteredLaunches() {
    let rows = [
      successRow(.success),
      yearRow(2016),
      yearRow(2006),
      sortOrderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filteredRows: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 3)
  }

  func test_apply_noMatches_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [successRow(.success), yearRow(2020)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 0)
  }

  func test_apply_noFilters_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 5)
  }

  private lazy var launchViewModels = [
    LaunchViewModel(launch: .arrange(launchDate: date(year: 2016), launchSuccess: true)),
    LaunchViewModel(launch: .arrange(launchDate: date(year: 2020), launchSuccess: false)),
    LaunchViewModel(launch: .arrange(launchDate: date(year: 2006), launchSuccess: true)),
    LaunchViewModel(launch: .arrange(launchDate: date(year: 2016), launchSuccess: true)),
    LaunchViewModel(launch: .arrange(launchDate: date(year: 2016), launchSuccess: false))
  ]

  private func date(year: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    let calendar = Calendar(identifier: .gregorian)
    return calendar.date(from: dateComponents)!
  }

  private func successRow(_ success: LaunchOutcome) -> TableRow {
    LaunchOutcomeTableRow(launchOutcome: success)
  }

  private func yearRow(_ year: Int) -> TableRow {
    LaunchYearTableRow(launchYear: year)
  }

  private func sortOrderRow(_ order: SortOrder) -> TableRow {
    SortTableRow(sortOrder: order)
  }

}
