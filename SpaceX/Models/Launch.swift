//
//  Launches.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

struct Launch: Decodable, Identifiable {
  
  let id = UUID()
  let missionName: String
  let rocket: Rocket
  let date: Date
  let launchSuccess: Bool?
  let links: Links

  private enum CodingKeys: String, CodingKey {
    case missionName = "mission_name"
    case rocket
    case date = "launch_date_local"
    case launchSuccess = "launch_success"
    case links
  }

}
