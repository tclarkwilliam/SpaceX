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

  func configure() {
    statementLabel.text = "{companyName} was founded by {founderName} in {year}. It has now {employees} employees, {launchSites} launch sites, and is valued at USD {valuation}"
  }

}
