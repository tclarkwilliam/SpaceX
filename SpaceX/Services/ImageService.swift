//
//  ImageService.swift
//  SpaceX
//
//  Created by Tom on 15/05/2021.
//

import UIKit

class ImageService {

  private let service: Service
  private let cache: Cache<CachedImage>
  private let path: String

  init(service: Service = Service(),
       cache: Cache<CachedImage> = Cache<CachedImage>(directory: .images),
       path: String) {
    self.service = service
    self.cache = cache
    self.path = path
  }

  func fetchMissionImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
    if let data = cache.retrieve(imageCacheName)?.data {
      completion(.success(UIImage(data: data)))
    } else {
      guard let url = URL(string: path) else { return completion(.failure(ServiceError.invalidURL)) }
      service.fetch(url: url) { data, response, error in
        guard let data = data else { return completion(.failure(ServiceError.invalidData)) }
        self.cache.save(CachedImage(data: data),
                        path: self.imageCacheName)
        completion(.success(UIImage(data: data)))
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
