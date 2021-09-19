//
//  SortTableRow.swift
//  SpaceX
//
//  Created by Tom on 12/09/2021.
//

import UIKit

class SortTableRow: TableRow {

  var isSelected: Bool = false
  var selectedIndexPath: IndexPath?

  let sortOrder: SortOrder

  init(sortOrder: SortOrder) {
    self.sortOrder = sortOrder
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: FilterTableViewCell = tableView.dequeue(indexPath)
    cell.accessoryType = isSelected ? .checkmark : .none
    let filter = Filter(value: sortOrder.rawValue)
    cell.accessibilityIdentifier = filter.value
    cell.configure(filter: filter)
    return cell
  }

}
