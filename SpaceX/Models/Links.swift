//
//  Links.swift
//  SpaceX
//
//  Created by Tom on 10/05/2021.
//

struct Links: Decodable {

  let missionImagePath: String?
  let article: String?
  let wikipedia: String?
  let video: String?

  private enum CodingKeys: String, CodingKey {
    case missionImagePath = "mission_patch_small"
    case article = "article_link"
    case wikipedia
    case video = "video_link"
  }

}