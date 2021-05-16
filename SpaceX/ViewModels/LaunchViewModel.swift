//
//  LaunchViewModel.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import UIKit

struct LaunchViewModel {

  private let launch: Launch

  init(launch: Launch) {
    self.launch = launch
  }

  var missionName: String {
    launch.missionName
  }

  var formattedRocket: String {
    "\(launch.rocket.name) / \(launch.rocket.type)"
  }

  func fetchMissionImage(completion: @escaping ((UIImage?) -> Void)) {
    guard let path = missionImagePath else { return }
    ImageService().fetchMissionImage(path: path) { result in
      guard case let .success(image) = result else { return }
      completion(image)
    }
  }

  var missionImagePath: String? {
    launch.links.missionImagePath
  }

  var articleURL: URL? {
    guard let articlePath = launch.links.article else { return nil }
    return URL(string: articlePath)
  }

  var wikipediaURL: URL? {
    guard let wikipediaPath = launch.links.wikipedia else { return nil }
    return URL(string: wikipediaPath)
  }

  var videoURL: URL? {
    guard let videoPath = launch.links.video else { return nil }
    return URL(string: videoPath)
  }

  var launchDate: String {
    dateFormatter.string(from: launch.date)
  }

  var isLaunchSuccessfull: Bool {
    launch.launchSuccess ?? false
  }

  var launchImage: UIImage? {
    isLaunchSuccessfull ? UIImage(systemName: GlobalConstants.checkmarkSymbol.rawValue) :
                          UIImage(systemName: GlobalConstants.crossSymbol.rawValue)
  }

  var launchImageTintColour: UIColor {
    isLaunchSuccessfull ? .systemGreen : .systemRed
  }

  var launchDateDaysPrefix: String {
    let startingPoint = launch.date < Date() ? "since" : "from"
    return "Days \(startingPoint) now:"
  }

  func launchDateDays(date: Date = Date()) -> String {
     "\(daysBetween(start: launch.date, end: date))"
  }

  var launchYear: Int {
    Calendar.current.dateComponents([.year],
                                    from: launch.date).year ?? 0
  }

  private func daysBetween(start: Date,
                           end: Date) -> Int {
    Calendar.current.dateComponents([.day],
                                    from: start,
                                    to: end).day ?? 0
  }

  // Make lazy or similar
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    return dateFormatter
  }()

}