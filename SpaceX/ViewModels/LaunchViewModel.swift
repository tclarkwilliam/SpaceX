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
    if let imagePath = launch.links.missionImagePath,
       let url = URL(string: imagePath) {
      Service().fetch(url: url) { data, response, error in
        guard let data = data, error == nil else { return }
        completion(UIImage(data: data))
      }
    }
  }

  var launchDate: String {
    dateFormatter.string(from: launch.date)
  }

  var isLaunchSuccessfull: Bool {
    launch.launchSuccess ?? false
  }

  var launchImage: UIImage? {
    isLaunchSuccessfull ? UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")
  }

  var launchImageTintColour: UIColor {
    isLaunchSuccessfull ? .green : .red
  }

  var launchDateDaysPrefix: String {
    let startingPoint = launch.date < Date() ? "since" : "from"
    return "Days \(startingPoint) now:"
  }

  func launchDateDays(date: Date = Date()) -> String {
     "\(daysBetween(start: launch.date, end: date))"
  }

  private func daysBetween(start: Date,
                           end: Date) -> Int {
    Calendar.current.dateComponents([.day],
                                    from: start,
                                    to: end).day!
  }

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    return dateFormatter
  }()

}
