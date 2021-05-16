//
//  CompanyTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

  static let identifier = String(describing: CompanyTableViewCell.self)

  @IBOutlet weak private var statementLabel: UILabel!

  func configure(viewModel: CompanyInfoViewModel) {
    statementLabel.text = viewModel.statement
  }

}
