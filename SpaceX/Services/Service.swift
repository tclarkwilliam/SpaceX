//
//  Service.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

class Service {

  typealias Completion<T> = (Result<T, ServiceError>) -> Void

  private let session: Session

  init(session: Session = URLSession(configuration: .default)) {
    let shouldUseStubbedSession = CommandLine.arguments.contains("UITests")
    self.session = shouldUseStubbedSession ? StubbedSession() : session
  }

  func fetch(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    performRequest(url: url, completion: { completion($0, $1) })
  }

  func fetch<T: Decodable>(url: URL?, completion: @escaping Completion<T>) {
    guard let url = url else { return completion(.failure(.invalidURL)) }
    performRequest(url: url) { data, error in
      if let error = error {
        completion(.failure(.error(error)))
        return
      }
      do {
        guard let data = data else { return completion(.failure(.invalidData)) }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedData = try decoder.decode(T.self, from: data)
        completion(.success(decodedData))
      } catch {
        completion(.failure(.decoding))
      }
    }
  }

  private func performRequest(url: URL, completion: @escaping ((Data?, Error?) -> Void)) {
    session.dataTask(with: url) { data, _, error in
      DispatchQueue.main.async {
        completion(data, error)
      }
    }.resume()
  }

}

extension Service {
  enum Constants: String {
    case baseURL = "https://api.spacexdata.com/v4/"
  }
}

enum ServiceError: Error {
  case invalidData
  case invalidURL
  case decoding
  case error(Error)

  var message: String {
    switch self {
    case .invalidData:
      return "invalid data"
    case .invalidURL:
      return "invalid URL"
    case .decoding:
      return "decoding"
    case .error(let error):
      return error.localizedDescription
    }
  }
}

extension ServiceError: Equatable {
  static func ==(lhs: ServiceError, rhs: ServiceError) -> Bool {
    switch (lhs, rhs) {
    case
      (.invalidData, invalidData),
      (.invalidURL, .invalidURL),
      (.decoding, .decoding),
      (.error(_), .error(_)):
      return true
    default:
      return false
    }
  }
}
