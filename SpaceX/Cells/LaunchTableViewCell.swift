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
  @IBOutlet weak private var startingPointLabel: UILabel!
  @IBOutlet weak private var daysLabel: UILabel!
  @IBOutlet weak private var outcomeImageView: UIImageView!

  func configure(viewModel: LaunchViewModel) {
    configureImage(placeholderImage)
    missionLabel.text = viewModel.missionName
    dateLabel.text = viewModel.launchDate
    startingPointLabel.text = viewModel.launchDateDaysPrefix
    daysLabel.text = viewModel.launchDateDays()
    outcomeImageView.image = viewModel.launchImage
    outcomeImageView.tintColor = viewModel.launchImageTintColour
  }

  func configureImage(_ image: UIImage?) {
    missionImageView.image = image
  }

  private var placeholderImage: UIImage? {
    let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
    return UIImage(systemName: "airplane.circle",
                   withConfiguration: configuration)
  }
  
}
