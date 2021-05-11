//
//  LaunchesSection.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

struct LaunchesSection: LaunchesSectionable {

  let launchViewModels: [LaunchViewModel]

  var title: String {
    Constants.title.rawValue
  }

  var numberOfRows: Int {
    launchViewModels.count
  }

}

private extension LaunchesSection {
  enum Constants: String {
    case title = "LAUNCHES"
  }
}
