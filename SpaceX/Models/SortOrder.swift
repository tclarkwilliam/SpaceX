//
//  SortOrder.swift
//  SpaceX
//
//  Created by Tom on 16/05/2021.
//

enum SortOrder: String {

  case ascending = "Ascending"
  case descending = "Descending"

  var isAscending: Bool {
    switch self {
    case .ascending:
      return true
    case .descending:
      return false
    }
  }

}
