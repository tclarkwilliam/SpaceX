//
//  FilterLaunchesViewController.swift
//  SpaceX
//
//  Created by Tom on 11/05/2021.
//

import UIKit

class FilterLaunchesViewController: UIViewController {

  @IBOutlet weak private var filterTableView: UITableView!

  static let identifier = String(describing: FilterLaunchesViewController.self)

  var updateLaunches: (([LaunchViewModel]) -> Void)?
  
  private var tableDataSource: FilterLaunchesTableDataSource?

  private let launchViewModels: [LaunchViewModel]

  init?(coder: NSCoder,
        launchViewModels: [LaunchViewModel]) {
    self.launchViewModels = launchViewModels
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureTableView()
    tableDataSource = FilterLaunchesTableDataSource(tableView: filterTableView,
                                                    launchViewModels: launchViewModels)
  }

  private func configureNavigationBar() {
    title = Constants.title.rawValue
    navigationItem.leftBarButtonItem = barButtonItem(imageName: GlobalConstants.crossSymbol.rawValue,
                                                     action: #selector(dismissViewController))
    navigationItem.rightBarButtonItem = barButtonItem(imageName: GlobalConstants.checkmarkSymbol.rawValue,
                                                      action: #selector(applyFilters))
  }

  private func barButtonItem(imageName: String,
                             action: Selector) -> UIBarButtonItem {
    .init(image: UIImage(systemName: imageName),
          style: .plain,
          target: self,
          action: action)
  }

  private func configureTableView() {
    filterTableView.accessibilityIdentifier = Constants.tableViewAccessibilityIdentifier.rawValue
    registerCells()
  }

  private func registerCells() {
    filterTableView.register(UINib(nibName: FilterTableViewCell.identifier, bundle: nil),
                             forCellReuseIdentifier: FilterTableViewCell.identifier)
  }

  @objc private func dismissViewController() {
    navigationController?.dismiss(animated: true)
  }

  @objc private func applyFilters() {
    guard let filteredRows = tableDataSource?.filteredRows else { return }
    let filterApplicator = LaunchesFilterApplicator(filteredRows: filteredRows,
                                                    launchViewModels: launchViewModels)
    updateLaunches?(filterApplicator.filteredLaunches())
    dismissViewController()
  }

}

private extension FilterLaunchesViewController {
  enum Constants: String {
    case title = "Filter Launches"
    case tableViewAccessibilityIdentifier = "FilterTableView"
  }
}
