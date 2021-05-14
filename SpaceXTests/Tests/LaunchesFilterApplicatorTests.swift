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
    let subject = LaunchesFilterApplicator(filters: [successRow(.success)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 3)
  }

  func test_apply_launchSuccess_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [successRow(.success), yearRow(2016)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 2)
  }

  func test_apply_launchFailure_launchYear_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [successRow(.failure), yearRow(2020)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 1)
  }

  func test_apply_sortOrder_ascending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [sortOrderRow(.ascending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 5)
    XCTAssertEqual(subject.apply().first?.launchYear, 2006)
    XCTAssertEqual(subject.apply().last?.launchYear, 2020)
  }

  func test_apply_sortOrder_descending_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [sortOrderRow(.descending)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 5)
    XCTAssertEqual(subject.apply().first?.launchYear, 2020)
    XCTAssertEqual(subject.apply().last?.launchYear, 2006)
  }

  func test_apply_launchSuccess_launchYear_sortOrder_returnsFilteredLaunches() {
    let rows = [
      successRow(.success),
      yearRow(2016),
      sortOrderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filters: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 2)
  }

  func test_apply_launchSuccess_multipleLaunchYears_sortOrder_returnsFilteredLaunches() {
    let rows = [
      successRow(.success),
      yearRow(2016),
      yearRow(2006),
      sortOrderRow(.ascending)
    ]
    let subject = LaunchesFilterApplicator(filters: rows,
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 3)
  }

  func test_apply_noMatches_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [successRow(.success), yearRow(2020)],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 0)
  }

  func test_apply_noFilters_returnsFilteredLaunches() {
    let subject = LaunchesFilterApplicator(filters: [],
                                           launchViewModels: launchViewModels)
    XCTAssertEqual(subject.apply().count, 5)
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

  private func successRow(_ success: LaunchOutcome) -> Row {
    let row = ValueRow<LaunchOutcome>()
    row.value = success
    return row
  }

  private func yearRow(_ year: Int) -> Row {
    let row = ValueRow<Int>()
    row.value = year
    return row
  }

  private func sortOrderRow(_ order: SortOrder) -> Row {
    let row = ValueRow<SortOrder>()
    row.value = order
    return row
  }

}
