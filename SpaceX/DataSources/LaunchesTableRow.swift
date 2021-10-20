//
//  LaunchesTableRow.swift
//  SpaceX
//
//  Created by Tom on 01/09/2021.
//

import UIKit

class LaunchesTableRow: TableRow {

  var didSelect: ((IndexPath) -> Void)?
  var isSelected: Bool = false
  
  private let viewModel: LaunchViewModel

  init(viewModel: LaunchViewModel) {
    self.viewModel = viewModel
  }

  func cell(tableView: UITableView,
            indexPath: IndexPath) -> UITableViewCell {
    let cell: LaunchTableViewCell = tableView.dequeue(indexPath)
    cell.tag = indexPath.row
    cell.configure(viewModel: viewModel)
    fetchMissionImage(viewModel: viewModel) { image in
      if cell.tag == indexPath.row {
        cell.configureImage(image)
      }
    }
    return cell
  }

  func didSelect(tableView: UITableView,
                 indexPath: IndexPath) {
    didSelect?(indexPath)
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
