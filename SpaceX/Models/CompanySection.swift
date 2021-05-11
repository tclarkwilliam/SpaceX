//
//  CompanySection.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

struct CompanySection: LaunchesSectionable {

  let companyInfoViewModel: CompanyInfoViewModel

  var title: String {
    Constants.title.rawValue
  }

  var numberOfRows: Int {
    1
  }

}

private extension CompanySection {
  enum Constants: String {
    case title = "COMPANY"
  }
}
