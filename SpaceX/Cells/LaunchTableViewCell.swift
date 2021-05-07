//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {

  static let identifier = String(describing: LaunchTableViewCell.self)

  @IBOutlet weak var missionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var rocketLabel: UILabel!
  @IBOutlet weak var daysLabel: UILabel!

  func configure(data: String) {}
  
}
