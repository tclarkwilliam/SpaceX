//
//  LaunchesService.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

class LaunchesService {

  typealias Completion = (Result<[Launch], Error>) -> Void

  private let service: Service

  init(service: Service = Service()) {
    self.service = service
  }

  func fetchLaunches(completion: @escaping Completion) {
    guard let url = url else { return }
    service.fetch(url: url) { data, response, error in
      self.handleResponse(data: data, completion: completion)
    }
  }

  private func handleResponse(data: Data?,
                              completion: Completion) {
    guard let data = data else { return completion(.failure(ServiceError.invalidData)) }
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let launches = try decoder.decode([Launch].self, from: data)
      completion(.success(launches))
    } catch {
      completion(.failure(error))
    }
  }

  private var url: URL? {
    URL(string: "\(Service.Constants.baseURL.rawValue)\(Constants.path.rawValue)")
  }

}

private extension LaunchesService {
  enum Constants: String {
    case path = "launches"
  }
}
