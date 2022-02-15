//
//  Service.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

class Service {

  private let session: Session

  init(session: Session = URLSession(configuration: .default)) {
    let shouldUseStubbedSession = CommandLine.arguments.contains("UITests")
    self.session = shouldUseStubbedSession ? StubbedSession() : session
  }

  func fetch(url: URL,
             completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    session.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        completion(data, response, error)
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
}
