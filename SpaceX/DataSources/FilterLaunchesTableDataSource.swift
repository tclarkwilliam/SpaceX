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
  private var successRow: LaunchOutcomeTableRow? = .init(launchOutcome: .success)
  private var failureRow: LaunchOutcomeTableRow? = .init(launchOutcome: .failure)
  private var ascendingRow: LaunchOrderTableRow? = .init(launchOrder: .ascending)
  private var descendingRow: LaunchOrderTableRow? = .init(launchOrder: .descending)

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
     launchOrderSection()]
  }

  private func launchOutcomeSection() -> TableViewSection {
    successRow?.didSelect = { [weak self] in
      guard let self = self else { return }
      self.failureRow?.deselect(tableView: self.tableView)
    }
    failureRow?.didSelect = { [weak self] in
      guard let self = self else { return }
      self.successRow?.deselect(tableView: self.tableView)
    }
    let rows = [successRow, failureRow].compactMap { $0 }
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

  private func launchOrderSection() -> TableViewSection {
    ascendingRow?.didSelect = { [weak self] in
      guard let self = self else { return }
      self.descendingRow?.deselect(tableView: self.tableView)
    }
    descendingRow?.didSelect = { [weak self] in
      guard let self = self else { return }
      self.ascendingRow?.deselect(tableView: self.tableView)
    }
    let rows = [ascendingRow, descendingRow].compactMap { $0 }
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
