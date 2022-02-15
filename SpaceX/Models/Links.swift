//
//  Links.swift
//  SpaceX
//
//  Created by Tom on 10/05/2021.
//

struct Links: Decodable {

  let patch: Patch?
  let article: String?
  let wikipedia: String?
  let video: String?

  private enum CodingKeys: String, CodingKey {
    case patch
    case article = "article_link"
    case wikipedia
    case video = "video_link"
  }

}

struct Patch: Decodable {
  let small: String?
}
