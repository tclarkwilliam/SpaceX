//
//  FilterLaunchesTableDataSource.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class FilterLaunchesTableDataSource: TableDataSource {

  var selectedFilters = [TableRow]()

  private let sections: [TableSection]

  override init(tableView: UITableView,
                sections: [TableSection]) {
    self.sections = sections
    super.init(tableView: tableView, sections: sections)
  }

  func removeFilters() {
    selectedFilters.removeAll()
  }

  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if !sections[indexPath.section].allowsMultipleSelection {
      configureSingleSelection(tableView: tableView, indexPath: indexPath)
    }
    return indexPath
  }

  private func configureSingleSelection(tableView: UITableView,
                                        indexPath: IndexPath) {
    let rows = sections[indexPath.section].rows
    let selectedRows = rows.filter { $0.isSelected }
    let currentRowNotSelected = !selectedRows.isEmpty
    if currentRowNotSelected,
       let selectedIndexPath = selectedRows.first?.selectedIndexPath {
      deselectPreviousRow(tableView: tableView,
                          indexPath: indexPath,
                          selectedIndexPath: selectedIndexPath)
    }
  }

  private func deselectPreviousRow(tableView: UITableView,
                                   indexPath: IndexPath,
                                   selectedIndexPath: IndexPath) {
    tableView.deselectRow(at: selectedIndexPath, animated: true)
    let cell = tableView.cellForRow(at: selectedIndexPath)
    cell?.accessoryType = .none
    let rows = sections[indexPath.section].rows
    let previousRow = rows[selectedIndexPath.row]
    let currentRow = rows[indexPath.row]
    previousRow.isSelected = currentRow.isSelected
    updateSelectedFilters(for: previousRow)
  }

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    row.isSelected = !row.isSelected
    updateSelectedFilters(for: row)
    row.selectedIndexPath = indexPath
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }

  private func updateSelectedFilters(for row: TableRow) {
    if row.isSelected {
      selectedFilters.append(row)
    } else if let rowToRemove = selectedFilters.firstIndex(where: { $0 === row }) {
      selectedFilters.remove(at: rowToRemove)
    }
  }

}

