//
//  Row.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

import Foundation

class Row: NSObject {

  let title: String
  var selected: Bool = false
  var selectedIndexPath: IndexPath?

  init(title: String = "") {
    self.title = title
  }

}

class ValueRow<T>: Row {
  var value: T?
}
