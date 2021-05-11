//
//  Rocket.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

struct Rocket: Decodable {

  let name: String
  let type: String

  private enum CodingKeys: String, CodingKey {
    case name = "rocket_name"
    case type = "rocket_type"
  }

}
