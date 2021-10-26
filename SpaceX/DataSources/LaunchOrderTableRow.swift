//
//  LaunchOrderTableRow.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class LaunchOrderTableRow: TableRow {

  var didSelect: (() -> Void)?
  var isSelected: Bool = false

  private var selectedIndexPath: IndexPath?

  private let launchOrder: LaunchOrder

  init(launchOrder: LaunchOrder) {
    self.launchOrder = launchOrder
  }

  var isAscending: Bool {
    launchOrder.isAscending
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: FilterTableViewCell = tableView.dequeue(indexPath)
    cell.accessoryType = isSelected ? .checkmark : .none
    let filter = Filter(value: launchOrder.rawValue)
    cell.accessibilityIdentifier = filter.value
    cell.configure(filter: filter)
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
