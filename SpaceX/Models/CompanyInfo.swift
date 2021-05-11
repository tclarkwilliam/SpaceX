//
//  CompanyInfo.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

struct CompanyInfo: Decodable, Equatable {

  let name: String
  let founder: String
  let founded: Int
  let employees: Int
  let valuation: Int
  let launchSites: Int

  private enum CodingKeys: String, CodingKey {
    case name
    case founder
    case founded
    case employees
    case valuation
    case launchSites = "launch_sites"
  }

}
