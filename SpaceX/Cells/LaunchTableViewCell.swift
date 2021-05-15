//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {

  static let identifier = String(describing: LaunchTableViewCell.self)

  @IBOutlet weak private var missionImageView: UIImageView!
  @IBOutlet weak private var missionLabel: UILabel!
  @IBOutlet weak private var dateLabel: UILabel!
  @IBOutlet weak private var rocketLabel: UILabel!
  @IBOutlet weak private var startingPointLabel: UILabel!
  @IBOutlet weak private var daysLabel: UILabel!
  @IBOutlet weak private var outcomeImageView: UIImageView!

  func configure(viewModel: LaunchViewModel) {
    viewModel.fetchMissionImage { self.missionImageView.image = $0 }
    missionLabel.text = viewModel.missionName
    rocketLabel.text = viewModel.formattedRocket
    dateLabel.text = viewModel.launchDate
    startingPointLabel.text = viewModel.launchDateDaysPrefix
    daysLabel.text = viewModel.launchDateDays()
    outcomeImageView.image = viewModel.launchImage
    outcomeImageView.tintColor = viewModel.launchImageTintColour
  }
  
}
