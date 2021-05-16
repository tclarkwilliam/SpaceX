//
//  TableViewSection.swift
//  SpaceX
//
//  Created by Tom on 07/05/2021.
//

struct TableViewSection {

  let title: String
  let allowsMultipleSelection: Bool
  private(set) var rows: [Row]

  public init(title: String,
              allowsMultipleSelection: Bool = false,
              rows: [Row]) {
    self.title = title
    self.allowsMultipleSelection = allowsMultipleSelection
    self.rows = rows
  }

  var numberOfRows: Int {
    rows.count
  }

}
