//
//  Links.swift
//  SpaceX
//
//  Created by Tom on 10/05/2021.
//

struct Links: Decodable {

  let missionImagePath: String?

  private enum CodingKeys: String, CodingKey {
    case missionImagePath = "mission_patch_small"
  }

}
