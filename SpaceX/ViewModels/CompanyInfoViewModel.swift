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

  var name: String {
    companyInfo.name
  }

  var founder: String {
    companyInfo.founder
  }

  var founded: Int {
    companyInfo.founded
  }

  var employees: Int {
    companyInfo.employees
  }

  var formattedValuation: String {
    guard let currencyCode = numberFormatter.currencyCode,
          let formattedValuation = numberFormatter.string(from: companyInfo.valuation as NSNumber) else { return "" }
    return "\(currencyCode) \(formattedValuation)"
  }

  var launchSites: Int {
    companyInfo.launchSites
  }

  private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "en_US")
    numberFormatter.numberStyle = .currency
    numberFormatter.currencySymbol = ""
    return numberFormatter
  }()

}
