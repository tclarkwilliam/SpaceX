//
//  LaunchYearTableRow.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class LaunchYearTableRow: TableRow {

  var didSelect: (() -> Void)?
  var isSelected: Bool = false
  
  private var selectedIndexPath: IndexPath?

  private let launchYear: Int

  init(launchYear: Int) {
    self.launchYear = launchYear
  }

  var year: Int {
    launchYear
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: FilterTableViewCell = tableView.dequeue(indexPath)
    cell.accessoryType = isSelected ? .checkmark : .none
    let filter = Filter(value: String(launchYear))
    cell.accessibilityIdentifier = filter.value
    cell.configure(filter: filter)
    return cell
  }

  func didSelect(tableView: UITableView,
                 indexPath: IndexPath) {
    isSelected = !isSelected
    tableView.reloadRows(at: [indexPath], with: .automatic)
    didSelect?()
  }

}
