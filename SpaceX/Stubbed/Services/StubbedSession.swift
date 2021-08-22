//
//  StubbedSession.swift
//  SpaceX
//
//  Created by Tom on 22/08/2021.
//

import Foundation

class StubbedSession: Session {

  func dataTask(with url: URL,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    switch url {
    case URL(string: "\(Service.Constants.baseURL.rawValue)info"):
      completionHandler(data(resource: "CompanyInfo"), nil, nil)
    case URL(string: "\(Service.Constants.baseURL.rawValue)launches"):
      completionHandler(data(resource: "Launches"), nil, nil)
    default:
      completionHandler(nil, nil, nil)
    }
    return URLSession.shared.dataTask(with: url)
  }

  private func data(resource: String) -> Data? {
    guard let stubbedResponse = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
          let data = try? Data(contentsOf: stubbedResponse) else { return nil }
    return data
  }

}

protocol Session {
  func dataTask(with url: URL,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Session {}
