//
//  LaunchOutcomeTableRow.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class LaunchOutcomeTableRow: TableRow {

  var didSelect: (() -> Void)?
  var isSelected: Bool = false
  
  private var selectedIndexPath: IndexPath?

  private let launchOutcome: LaunchOutcome

  init(launchOutcome: LaunchOutcome) {
    self.launchOutcome = launchOutcome
  }

  var isLaunchSuccessful: Bool {
    launchOutcome.isLaunchSuccessful
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: FilterTableViewCell = tableView.dequeue(indexPath)
    cell.accessoryType = isSelected ? .checkmark : .none
    let launchOutcomeValue = launchOutcome.rawValue
    cell.accessibilityIdentifier = launchOutcomeValue
    cell.configure(filter: Filter(value: launchOutcomeValue))
    return cell
  }

  func didSelect(tableView: UITableView,
                 indexPath: IndexPath) {
    isSelected = !isSelected
    tableView.reloadRows(at: [indexPath], with: .automatic)
    selectedIndexPath = indexPath
    didSelect?()
  }

  func deselect(tableView: UITableView) {
    guard let selectedIndexPath = selectedIndexPath else { return }
    tableView.deselectRow(at: selectedIndexPath, animated: true)
    isSelected = false
    tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
  }

}
