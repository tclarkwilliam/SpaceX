//
//  TableDataSource.swift
//  SpaceX
//
//  Created by Tom on 01/09/2021.
//

import UIKit

class TableDataSource: NSObject,
                       UITableViewDataSource,
                       UITableViewDelegate {

  private let sections: [TableSection]

  init(tableView: UITableView,
       sections: [TableSection]) {
    self.sections = sections
    super.init()
    tableView.dataSource = self
    tableView.delegate = self
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    sections[section].title
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    sections[section].rows.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    sections[indexPath.section].rows[indexPath.row].cell(tableView: tableView,
                                                         indexPath: indexPath)
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    sections[indexPath.section].rows[indexPath.row].didSelect(tableView: tableView,
                                                              indexPath: indexPath)
  }

}
