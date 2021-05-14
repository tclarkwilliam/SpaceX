//
//  FilterLaunchesViewController.swift
//  SpaceX
//
//  Created by Tom on 11/05/2021.
//

import UIKit

class FilterLaunchesViewController: UIViewController {

  @IBOutlet weak var filterTableView: UITableView!

  var launchViewModels: [LaunchViewModel]?
  var selectedFilters: [Row] = [Row]()
  var updateLaunches: (([LaunchViewModel]) -> Void)?

  private enum Constants: String {
    case title = "Filter Launches"
  }

  private lazy var sections = [TableViewSection]()

  static let identifier = String(describing: FilterLaunchesViewController.self)

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    filterTableView.dataSource = self
    filterTableView.delegate = self
    let nib = UINib(nibName: FilterTableViewCell.identifier, bundle: nil)
    filterTableView.register(nib, forCellReuseIdentifier: FilterTableViewCell.identifier)
    selectedFilters.removeAll()
    configureLaunchSuccessSection()
    configureLaunchYearsSection()
    configureSortSection()
  }

  private func configureLaunchSuccessSection() {
    let successRow = ValueRow<LaunchOutcome>(title: LaunchOutcome.success.rawValue)
    successRow.value = .success
    let failureRow = ValueRow<LaunchOutcome>(title: LaunchOutcome.failure.rawValue)
    failureRow.value = .failure
    let rows = [successRow, failureRow]
    let launchSuccessSection = TableViewSection(title: "Launch Success",
                                                rows: rows)
    sections.append(launchSuccessSection)
  }

  private func configureLaunchYearsSection() {
    let launchYears = launchViewModels!.map { $0.launchYear }
    var uniqueYears = Array(Set(launchYears))
    uniqueYears.sort()
    let rows: [ValueRow<Int>] = uniqueYears.compactMap { year in
      let yearRow = ValueRow<Int>(title: String(year))
      yearRow.value = year
      return yearRow
    }
    let launchYearsSection = TableViewSection(title: "Launch Years",
                                              allowsMultipleSelection: true,
                                              rows: rows)
    sections.append(launchYearsSection)
  }

  private func configureSortSection() {
    let ascendingRow = ValueRow<SortOrder>(title: SortOrder.ascending.rawValue)
    ascendingRow.value = .ascending
    let descendingRow = ValueRow<SortOrder>(title: SortOrder.descending.rawValue)
    descendingRow.value = .descending
    let rows = [ascendingRow, descendingRow]
    let sortSection = TableViewSection(title: "Sort",
                                       rows: rows)
    sections.append(sortSection)
  }

  private func configureNavigationBar() {
    title = Constants.title.rawValue
    navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "xmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(dismissViewController))
    navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "checkmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(applyFilters))
  }

  @objc private func dismissViewController() {
    navigationController?.dismiss(animated: true)
  }

  @objc private func applyFilters() {
    guard let launchViewModels = launchViewModels else { return }
    let launchesFilterApplicator = LaunchesFilterApplicator(filters: selectedFilters,
                                                            launchViewModels: launchViewModels)
    updateLaunches?(launchesFilterApplicator.apply())
    dismissViewController()
  }

}

extension FilterLaunchesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let section = sections[indexPath.section]
    let rows = sections[indexPath.section].rows
    let selectedRows = rows.filter { $0.selected }
    if !section.allowsMultipleSelection {
      let currentRowNotSelected = !selectedRows.isEmpty
      if currentRowNotSelected {
        if let selectedIndexPath = selectedRows.first?.selectedIndexPath {
          tableView.deselectRow(at: selectedIndexPath, animated: true)
          let cell = tableView.cellForRow(at: selectedIndexPath)
          cell?.accessoryType = .none
          let previousRow = section.rows[selectedIndexPath.row]
          let currentRow = section.rows[indexPath.row]
          previousRow.selected = currentRow.selected

          if currentRow is ValueRow<LaunchOutcome> {
            let launchSuccessRows = selectedFilters.filter { $0 is ValueRow<LaunchOutcome> }
            selectedFilters = selectedFilters.filter { !launchSuccessRows.contains($0) }
          }
          if currentRow is ValueRow<SortOrder> {
            let sortOrderRows = selectedFilters.filter { $0 is ValueRow<SortOrder> }
            selectedFilters = selectedFilters.filter { !sortOrderRows.contains($0) }
          }
        }
      }
    }
    return indexPath
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    row.selected = !row.selected
    if row.selected {
      selectedFilters.append(row)
    } else if let rowToRemove = selectedFilters.firstIndex(of: row) {
      selectedFilters.remove(at: rowToRemove)
    }
    row.selectedIndexPath = indexPath
    print(selectedFilters)
    tableView.reloadRows(at: [indexPath], with: .automatic)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
    let row = sections[indexPath.section].rows[indexPath.row]
    cell.accessoryType = row.selected ? .checkmark : .none
    cell.configure(row: row)
    return cell
  }

}
