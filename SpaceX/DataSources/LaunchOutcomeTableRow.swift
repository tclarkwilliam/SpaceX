//
//  LaunchOutcomeTableRow.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class LaunchOutcomeTableRow: TableRow {

  var isSelected: Bool = false
  var selectedIndexPath: IndexPath?

  let launchOutcome: LaunchOutcome

  init(launchOutcome: LaunchOutcome) {
    self.launchOutcome = launchOutcome
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: FilterTableViewCell = tableView.dequeue(indexPath)
    cell.accessoryType = isSelected ? .checkmark : .none
    let filter = Filter(value: launchOutcome.rawValue)
    cell.accessibilityIdentifier = filter.value
    cell.configure(filter: filter)
    return cell
  }

}
