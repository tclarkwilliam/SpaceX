//
//  TableViewSection.swift
//  SpaceX
//
//  Created by Tom on 01/09/2021.
//

struct TableViewSection: TableSection {
  var title: String
  var rows: [TableRow]
  var allowsMultipleSelection: Bool = false
}
