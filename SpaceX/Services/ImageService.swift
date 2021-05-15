//
//  ImageService.swift
//  SpaceX
//
//  Created by Tom on 15/05/2021.
//

import UIKit

class ImageService {

  private let service: Service

  init(service: Service = Service()) {
    self.service = service
  }

  func fetchMissionImage(path: String,
                         completion: @escaping (Result<UIImage?, Error>) -> Void) {
    let cache = Cache<CachedImage>(directory: CachePath.images.rawValue,
                                   filename: imageCacheName(path))
    if let data = cache.retrieve?.data {
      completion(.success(UIImage(data: data)))
      print("CACHED")
    } else {
      guard let url = URL(string: path) else { return completion(.failure(ServiceError.invalidURL)) }
      Service().fetch(url: url) { data, response, error in
        guard let data = data else { return completion(.failure(ServiceError.invalidData)) }
        cache.save(CachedImage(data: data))
        completion(.success(UIImage(data: data)))
        print("FETCHED")
      }
    }
  }

  private func imageCacheName(_ path: String) -> String {
    return path
      .replacingOccurrences(of: Constants.scheme.rawValue, with: Constants.empty.rawValue)
      .replacingOccurrences(of: Constants.slash.rawValue, with: Constants.underscore.rawValue)
      .replacingOccurrences(of: Constants.png.rawValue, with: Constants.empty.rawValue)
  }

}

private enum Constants: String {
  case scheme = "https://"
  case slash = "/"
  case underscore = "_"
  case png = ".png"
  case empty = ""
}
