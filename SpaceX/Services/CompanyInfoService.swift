//
//  CompanyInfoService.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

class CompanyInfoService {

  typealias Completion = (Result<CompanyInfo, Error>) -> Void

  private let service: Service

  init(service: Service = Service()) {
    self.service = service
  }

  func fetchInfo(completion: @escaping Completion) {
    service.fetch(url: url) { data, response, error in
      self.handleResponse(data: data, completion: completion)
    }
  }

  private func handleResponse(data: Data?,
                              completion: Completion) {
    guard let data = data else { return completion(.failure(ServiceError.invalidData)) }
    do {
      let companyInfo = try JSONDecoder().decode(CompanyInfo.self, from: data)
      completion(.success(companyInfo))
    } catch {
      completion(.failure(error))
    }
  }

  private var url: URL {
    URL(string: "\(Service.Constants.baseURL.rawValue)\(Constants.path.rawValue)")!
  }

}

private extension CompanyInfoService {
  enum Constants: String {
    case path = "info"
  }
}