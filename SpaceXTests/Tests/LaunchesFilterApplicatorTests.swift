//
//  LaunchesFilterApplicatorTests.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import XCTest

@testable import SpaceX

class LaunchesFilterApplicatorTests: XCTestCase {

  func test_apply_launchOutcome_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [outcomeRow(.success)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 3)
  }

  func test_apply_launchOutcome_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [outcomeRow(.success), yearRow(2016)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 2)
  }

  func test_apply_launchFailure_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [outcomeRow(.failure), yearRow(2020)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 1)
  }

  func test_apply_launchOrder_ascending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [orderRow(.ascending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 5)
    XCTAssertEqual(subject.filteredLaunches().first?.launchYear, 2006)
    XCTAssertEqual(subject.filteredLaunches().last?.launchYear, 2020)
  }

  func test_apply_launchOrder_descending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [orderRow(.descending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 5)
    XCTAssertEqual(subject.filteredLaunches().first?.launchYear, 2020)
    XCTAssertEqual(subject.filteredLaunches().last?.launchYear, 2006)
  }

  func test_apply_launchOutcome_launchYear_launchOrder_returnsFilteredLaunches() {
    let rows = [
      outcomeRow(.success),
      yearRow(2016),
      orderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filteredRows: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 2)
  }

  func test_apply_launchOutcome_multipleLaunchYears_launchOrder_returnsFilteredLaunches() {
    let rows = [
      outcomeRow(.success),
      yearRow(2016),
      yearRow(2006),
      orderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filteredRows: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.filteredLaunches().count, 3)
  }

  func test_apply_noMatches_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filteredRows: [outcomeRow(.success), yearRow(2020)],
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

  private func outcomeRow(_ outcome: LaunchOutcome) -> TableRow {
    LaunchOutcomeTableRow(launchOutcome: outcome)
  }

  private func yearRow(_ year: Int) -> TableRow {
    LaunchYearTableRow(launchYear: year)
  }

  private func orderRow(_ order: LaunchOrder) -> TableRow {
    LaunchOrderTableRow(launchOrder: order)
  }

}
