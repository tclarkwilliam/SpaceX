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
    tableDataSource?.removeFilters()
    tableDataSource = FilterLaunchesTableDataSource(tableView: filterTableView,
                                                    sections: [launchSuccessSection(),
                                                               launchYearsSection(),
                                                               sortSection()])
  }

  private func configureNavigationBar() {
    title = Constants.title.rawValue
    navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: GlobalConstants.crossSymbol.rawValue),
                                             style: .plain,
                                             target: self,
                                             action: #selector(dismissViewController))
    navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: GlobalConstants.checkmarkSymbol.rawValue),
                                             style: .plain,
                                             target: self,
                                             action: #selector(applyFilters))
  }

  @objc private func dismissViewController() {
    navigationController?.dismiss(animated: true)
  }

  private func configureTableView() {
    filterTableView.accessibilityIdentifier = Constants.tableViewAccessibilityIdentifier.rawValue
    registerCells()
  }

  private func registerCells() {
    let nib = UINib(nibName: FilterTableViewCell.identifier, bundle: nil)
    filterTableView.register(nib, forCellReuseIdentifier: FilterTableViewCell.identifier)
  }

  private func launchSuccessSection() -> TableViewSection {
    TableViewSection(title: Constants.launchSuccess.rawValue,
                     rows: [LaunchOutcomeTableRow(launchOutcome: .success),
                            LaunchOutcomeTableRow(launchOutcome: .failure)])
  }

  private func launchYearsSection() -> TableViewSection {
    TableViewSection(title: Constants.launchYears.rawValue,
                     rows: launchYears(),
                     allowsMultipleSelection: true)
  }

  private func launchYears() -> [LaunchYearTableRow] {
    let launchYears = launchViewModels.map { $0.launchYear }
    var uniqueYears = Array(Set(launchYears))
    uniqueYears.sort()
    return uniqueYears.compactMap { LaunchYearTableRow(launchYear: $0) }
  }

  private func sortSection() -> TableViewSection {
    TableViewSection(title: Constants.sort.rawValue,
                     rows: [SortTableRow(sortOrder: .ascending),
                            SortTableRow(sortOrder: .descending)])
  }

  @objc private func applyFilters() {
    guard let filters = tableDataSource?.selectedFilters else { return }
    let filterApplicator = LaunchesFilterApplicator(filters: filters, launchViewModels: launchViewModels)
    updateLaunches?(filterApplicator.apply())
    dismissViewController()
  }

}

private extension FilterLaunchesViewController {
  enum Constants: String {
    case title = "Filter Launches"
    case launchSuccess = "Launch Success"
    case launchYears = "Launch Years"
    case sort = "Sort"
    case tableViewAccessibilityIdentifier = "FilterTableView"
  }
}
