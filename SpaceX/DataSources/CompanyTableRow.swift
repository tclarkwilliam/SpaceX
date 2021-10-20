//
//  CompanyTableRow.swift
//  SpaceX
//
//  Created by Tom on 01/09/2021.
//

import UIKit

class CompanyTableRow: TableRow {

  var isSelected: Bool = false
  
  private let viewModel: CompanyInfoViewModel

  init(viewModel: CompanyInfoViewModel) {
    self.viewModel = viewModel
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: CompanyTableViewCell = tableView.dequeue(indexPath)
    cell.selectionStyle = .none
    cell.configure(viewModel: viewModel)
    return cell
  }

}
