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

  private var selectedFilters = [Row]()
  private lazy var sections = [TableViewSection]()

  private let launchViewModels: [LaunchViewModel]

  init?(coder: NSCoder, launchViewModels: [LaunchViewModel]) {
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
    selectedFilters.removeAll()
    configureLaunchSuccessSection()
    configureLaunchYearsSection()
    configureSortSection()
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
    filterTableView.dataSource = self
    filterTableView.delegate = self
    registerCells()
  }

  private func registerCells() {
    let nib = UINib(nibName: FilterTableViewCell.identifier, bundle: nil)
    filterTableView.register(nib, forCellReuseIdentifier: FilterTableViewCell.identifier)
  }


  private func configureLaunchSuccessSection() {
    let successRow = ValueRow<LaunchOutcome>(title: LaunchOutcome.success.rawValue)
    successRow.value = .success
    let failureRow = ValueRow<LaunchOutcome>(title: LaunchOutcome.failure.rawValue)
    failureRow.value = .failure
    let launchSuccessSection = TableViewSection(title: Constants.launchSuccess.rawValue,
                                                rows: [successRow, failureRow])
    sections.append(launchSuccessSection)
  }

  private func configureLaunchYearsSection() {
    let section = TableViewSection(title: Constants.launchYears.rawValue,
                                   allowsMultipleSelection: true,
                                   rows: launchYearRow)
    sections.append(section)
  }

  private var launchYearRow: [ValueRow<Int>] {
    let launchYears = launchViewModels.map { $0.launchYear }
    var uniqueYears = Array(Set(launchYears))
    uniqueYears.sort()
    return uniqueYears.compactMap { year in
      let row = ValueRow<Int>(title: String(year))
      row.value = year
      return row
    }
  }

  private func configureSortSection() {
    let ascendingRow = ValueRow<SortOrder>(title: SortOrder.ascending.rawValue)
    ascendingRow.value = .ascending
    let descendingRow = ValueRow<SortOrder>(title: SortOrder.descending.rawValue)
    descendingRow.value = .descending
    let sortSection = TableViewSection(title: Constants.sort.rawValue,
                                       rows: [ascendingRow, descendingRow])
    sections.append(sortSection)
  }

  @objc private func applyFilters() {
    let filterApplicator = LaunchesFilterApplicator(filters: selectedFilters, launchViewModels: launchViewModels)
    updateLaunches?(filterApplicator.apply())
    dismissViewController()
  }

}

extension FilterLaunchesViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    sections[section].numberOfRows
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    sections[section].title
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier,
                                             for: indexPath) as! FilterTableViewCell
    let row = sections[indexPath.section].rows[indexPath.row]
    cell.accessoryType = row.selected ? .checkmark : .none
    cell.configure(row: row)
    return cell
  }

}

extension FilterLaunchesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if !sections[indexPath.section].allowsMultipleSelection {
      configureSingleSelection(tableView: tableView, indexPath: indexPath)
    }
    return indexPath
  }

  private func configureSingleSelection(tableView: UITableView,
                                        indexPath: IndexPath) {
    let rows = sections[indexPath.section].rows
    let selectedRows = rows.filter { $0.selected }
    let currentRowNotSelected = !selectedRows.isEmpty
    if currentRowNotSelected,
       let selectedIndexPath = selectedRows.first?.selectedIndexPath {
      deselectPreviousRow(tableView: tableView,
                          indexPath: indexPath,
                          selectedIndexPath: selectedIndexPath)
    }
  }

  private func deselectPreviousRow(tableView: UITableView,
                                   indexPath: IndexPath,
                                   selectedIndexPath: IndexPath) {
    tableView.deselectRow(at: selectedIndexPath, animated: true)
    let cell = tableView.cellForRow(at: selectedIndexPath)
    cell?.accessoryType = .none
    let rows = sections[indexPath.section].rows
    let previousRow = rows[selectedIndexPath.row]
    let currentRow = rows[indexPath.row]
    previousRow.selected = currentRow.selected
    removePreviousSelectionFromSelectedFilters(previousRow: previousRow)
  }

  private func removePreviousSelectionFromSelectedFilters(previousRow: Row) {
    if previousRow is ValueRow<LaunchOutcome> {
      let launchOutcomeRows = selectedFilters.filter { $0 is ValueRow<LaunchOutcome> }
      selectedFilters = selectedFilters.filter { !launchOutcomeRows.contains($0) }
    }
    if previousRow is ValueRow<SortOrder> {
      let sortOrderRows = selectedFilters.filter { $0 is ValueRow<SortOrder> }
      selectedFilters = selectedFilters.filter { !sortOrderRows.contains($0) }
    }
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    row.selected = !row.selected
    updateSelectedFilters(for: row)
    row.selectedIndexPath = indexPath
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }

  private func updateSelectedFilters(for row: Row) {
    if row.selected {
      selectedFilters.append(row)
    } else if let rowToRemove = selectedFilters.firstIndex(of: row) {
      selectedFilters.remove(at: rowToRemove)
    }
  }

}

private extension FilterLaunchesViewController {
  enum Constants: String {
    case title = "Filter Launches"
    case launchSuccess = "Launch Success"
    case launchYears = "Launch Years"
    case sort = "Sort"
  }
}
