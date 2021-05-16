//
//  LaunchOutcome.swift
//  SpaceX
//
//  Created by Tom on 16/05/2021.
//

enum LaunchOutcome: String {

  case success = "Success"
  case failure = "Failure"

  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }

}
