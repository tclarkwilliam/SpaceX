//
//  FilterLaunchesTableDataSource.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class FilterLaunchesTableDataSource {

  private var filterRows = [TableRow]()
  private var dataSource: TableDataSource?

  private let tableView: UITableView
  private let launchViewModels: [LaunchViewModel]

  init(tableView: UITableView,
       launchViewModels: [LaunchViewModel]) {
    self.tableView = tableView
    self.launchViewModels = launchViewModels
    dataSource = TableDataSource(tableView: tableView,
                                 sections: sections())
  }

  var filteredRows: [TableRow] {
    filterRows.filter { $0.isSelected }
  }

  private func sections() -> [TableSection] {
    [launchOutcomeSection(),
     launchYearsSection(),
     sortSection()]
  }

  private func launchOutcomeSection() -> TableViewSection {
    let successRow = LaunchOutcomeTableRow(launchOutcome: .success)
    let failureRow = LaunchOutcomeTableRow(launchOutcome: .failure)
    successRow.didSelect = { failureRow.deselect(tableView: self.tableView) }
    failureRow.didSelect = { successRow.deselect(tableView: self.tableView) }
    let rows = [successRow, failureRow]
    filterRows.append(contentsOf: rows)
    return TableViewSection(title: Constants.launchSuccess.rawValue,
                            rows: rows)
  }

  private func launchYearsSection() -> TableViewSection {
    let rows = launchYearRows()
    filterRows.append(contentsOf: rows)
    return TableViewSection(title: Constants.launchYears.rawValue,
                            rows: rows,
                            allowsMultipleSelection: true)
  }

  private func launchYearRows() -> [LaunchYearTableRow] {
    let launchYears = launchViewModels.map { $0.launchYear }
    var uniqueYears = Array(Set(launchYears))
    uniqueYears.sort()
    return uniqueYears.compactMap { LaunchYearTableRow(launchYear: $0) }
  }

  private func sortSection() -> TableViewSection {
    let ascendingRow = SortTableRow(sortOrder: .ascending)
    let descendingRow = SortTableRow(sortOrder: .descending)
    ascendingRow.didSelect = { descendingRow.deselect(tableView: self.tableView) }
    descendingRow.didSelect = { ascendingRow.deselect(tableView: self.tableView) }
    let rows = [ascendingRow, descendingRow]
    filterRows.append(contentsOf: rows)
    return TableViewSection(title: Constants.sort.rawValue,
                            rows: rows)
  }

}

private extension FilterLaunchesTableDataSource {
  enum Constants: String {
    case launchSuccess = "Launch Success"
    case launchYears = "Launch Years"
    case sort = "Sort"
  }
}
