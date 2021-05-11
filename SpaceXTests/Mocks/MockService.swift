//
//  MockService.swift
//  SpaceXTests
//
//  Created by Tom on 11/05/2021.
//

import Foundation

@testable import SpaceX

class MockService: Service {

  var data: Data?
  var response: URLResponse?
  var error: Error?

  override func fetch(url: URL,
                      completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    completion(data, response, error)
  }

}
