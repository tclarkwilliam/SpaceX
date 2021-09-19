//
//  FilterTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 12/05/2021.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

  @IBOutlet weak private var titleLabel: UILabel!

  static let identifier = String(describing: FilterTableViewCell.self)

  func configure(filter: Filter) {
    titleLabel.text = filter.value
  }

}

struct Filter {
  let value: String
}
