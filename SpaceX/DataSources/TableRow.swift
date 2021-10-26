//
//  TableRow.swift
//  SpaceX
//
//  Created by Tom on 01/09/2021.
//

import UIKit

protocol TableRow: AnyObject {
  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell
  func didSelect(tableView: UITableView,
                 indexPath: IndexPath)
  var isSelected: Bool { get set }
}

extension TableRow {
  func didSelect(tableView: UITableView,
                 indexPath: IndexPath) {}
}
