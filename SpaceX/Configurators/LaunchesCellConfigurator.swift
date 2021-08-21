//
//  LaunchesCellConfigurator.swift
//  SpaceX
//
//  Created by Tom on 21/08/2021.
//

import UIKit

class LaunchesCellConfigurator {

  private let tableView: UITableView
  private let sections: [TableViewSection]
  private let indexPath: IndexPath

  init(tableView: UITableView,
       sections: [TableViewSection],
       indexPath: IndexPath) {
    self.tableView = tableView
    self.sections = sections
    self.indexPath = indexPath
  }

  func cell() -> UITableViewCell {
    if let cell = companyCell() {
      return cell
    }
    if let cell = launchCell() {
      return cell
    }
    return UITableViewCell()
  }

  private func companyCell() -> CompanyTableViewCell? {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.identifier,
                                                   for: indexPath) as? CompanyTableViewCell,
          let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<CompanyInfoViewModel>,
          let viewModel = row.value else { return nil }
    cell.selectionStyle = .none
    cell.configure(viewModel: viewModel)
    return cell
  }

  private func launchCell() -> LaunchTableViewCell? {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier,
                                                   for: indexPath) as? LaunchTableViewCell,
          let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<LaunchViewModel>,
          let viewModel = row.value else { return nil }
    cell.tag = indexPath.row
    cell.configure(viewModel: viewModel)
    fetchMissionImage(viewModel: viewModel) { image in
      if cell.tag == self.indexPath.row {
        cell.configureImage(image)
      }
    }
    return cell
  }

  private func fetchMissionImage(viewModel: LaunchViewModel,
                                 completion: @escaping ((UIImage?) -> Void)) {
    guard let imagePath = viewModel.missionImagePath else { return }
    ImageService(path: imagePath).fetchMissionImage { result in
      guard case let .success(image) = result else { return }
      completion(image)
    }
  }

}
