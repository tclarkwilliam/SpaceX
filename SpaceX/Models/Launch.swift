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
  let date: Date
  let launchSuccess: Bool?
  let links: Links

  private enum CodingKeys: String, CodingKey {
    case missionName = "name"
    case date = "date_local"
    case launchSuccess = "success"
    case links
  }

}
