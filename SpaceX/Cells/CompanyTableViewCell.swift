//
//  CompanyTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

  static let identifier = String(describing: CompanyTableViewCell.self)

  @IBOutlet weak var statementLabel: UILabel!

  func configure(viewModel: CompanyInfoViewModel) {
    statementLabel.text = "\(viewModel.name) was founded by \(viewModel.founder) in \(viewModel.founded). It has now \(viewModel.employees) employees, \(viewModel.launchSites) launch sites, and is valued at \(viewModel.formattedValuation)"
  }

}
