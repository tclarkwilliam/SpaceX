//
//  CompanyInfoViewModel.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

struct CompanyInfoViewModel {

  private let companyInfo: CompanyInfo

  init(companyInfo: CompanyInfo) {
    self.companyInfo = companyInfo
  }

  var statement: String {
    return "\(companyInfo.name) was founded by \(companyInfo.founder) in \(companyInfo.founded). It has now \(companyInfo.employees) employees, \(companyInfo.launchSites) launch sites, and is valued at \(formattedValuation)"
  }

  private var formattedValuation: String {
    guard let currencyCode = Self.numberFormatter.currencyCode,
          let formattedValuation = Self.numberFormatter.string(from: companyInfo.valuation as NSNumber) else { return "" }
    return "\(currencyCode) \(formattedValuation)"
  }

  private static let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "en_US")
    numberFormatter.numberStyle = .currency
    numberFormatter.currencySymbol = ""
    return numberFormatter
  }()

}

protocol ServiceConfig {
  static var url: URL? { get }
}

final class CompanyInfoServiceConfig: ServiceConfig {

  static var url: URL? {
    URL(string: "\(Service.Constants.baseURL.rawValue)company")
  }

}
