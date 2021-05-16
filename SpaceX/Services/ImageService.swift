//
//  ImageService.swift
//  SpaceX
//
//  Created by Tom on 15/05/2021.
//

import UIKit

class ImageService {

  lazy var cache = Cache<CachedImage>(directory: CachePath.images.rawValue,
                                      filename: imageCacheName)

  private let service: Service
  private let path: String

  init(service: Service = Service(),
       path: String) {
    self.service = service
    self.path = path
  }

  func fetchMissionImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
    if let data = cache.retrieve?.data {
      completion(.success(UIImage(data: data)))
      print("CACHED")
    } else {
      guard let url = URL(string: path) else { return completion(.failure(ServiceError.invalidURL)) }
      service.fetch(url: url) { data, response, error in
        guard let data = data else { return completion(.failure(ServiceError.invalidData)) }
        self.cache.save(CachedImage(data: data))
        completion(.success(UIImage(data: data)))
        print("FETCHED")
      }
    }
  }

  private var imageCacheName: String {
    return path
      .replacingOccurrences(of: Constants.scheme.rawValue, with: Constants.empty.rawValue)
      .replacingOccurrences(of: Constants.slash.rawValue, with: Constants.underscore.rawValue)
      .replacingOccurrences(of: Constants.png.rawValue, with: Constants.empty.rawValue)
  }

}

private extension ImageService {
  enum Constants: String {
    case scheme = "https://"
    case slash = "/"
    case underscore = "_"
    case png = ".png"
    case empty = ""
  }
}
