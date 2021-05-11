//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {

  static let identifier = String(describing: LaunchTableViewCell.self)

  @IBOutlet private weak var missionImageView: UIImageView!
  @IBOutlet private weak var missionLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var rocketLabel: UILabel!
  @IBOutlet private weak var startingPointLabel: UILabel!
  @IBOutlet private weak var daysLabel: UILabel!
  @IBOutlet private weak var outcomeImageView: UIImageView!

  func configure(viewModel: LaunchViewModel) {
//    viewModel.fetchMissionImage { self.missionImageView.image = $0 }
    missionLabel.text = viewModel.missionName
    rocketLabel.text = viewModel.formattedRocket
    dateLabel.text = viewModel.launchDate
    startingPointLabel.text = viewModel.launchDateDaysPrefix
    daysLabel.text = viewModel.launchDateDays()
    outcomeImageView.image = viewModel.launchImage
    outcomeImageView.tintColor = viewModel.launchImageTintColour
  }
  
}
