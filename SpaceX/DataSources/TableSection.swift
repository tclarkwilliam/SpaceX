//
//  TableSection.swift
//  SpaceX
//
//  Created by Tom on 19/09/2021.
//

protocol TableSection {
  var title: String { get }
  var rows: [TableRow] { get }
  var allowsMultipleSelection: Bool { get }
}

extension TableSection {
  var allowsMultipleSelection: Bool { false }
}
