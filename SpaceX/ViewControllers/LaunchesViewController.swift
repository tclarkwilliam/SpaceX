//
//  ViewController.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchesViewController: UIViewController {

  @IBOutlet weak private var launchesTableView: UITableView!
  @IBOutlet weak private var stateView: LaunchesStateView!

  private var sections = [TableViewSection]()
  private var launchesSection: TableViewSection?
  private var launchViewModels: [LaunchViewModel]?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.title.rawValue
    configureTableView()
    fetchCompanyInfo()
  }

  private func configureTableView() {
    launchesTableView.dataSource = self
    launchesTableView.delegate = self
    registerCells()
  }

  private func registerCells() {
    let companyNib = UINib(nibName: CompanyTableViewCell.identifier, bundle: nil)
    launchesTableView.register(companyNib, forCellReuseIdentifier: CompanyTableViewCell.identifier)
    let launchNib = UINib(nibName: LaunchTableViewCell.identifier, bundle: nil)
    launchesTableView.register(launchNib, forCellReuseIdentifier: LaunchTableViewCell.identifier)
  }

  private func fetchCompanyInfo() {
    showLoading()
    CompanyInfoService().fetchInfo { result in
      switch result {
      case .success(let companyInfo):
        self.configureCompanyInfoSection(from: companyInfo)
        self.fetchLaunches()
      case .failure(_):
        self.showError()
      }
    }
  }

  private func configureCompanyInfoSection(from companyInfo: CompanyInfo) {
    let section = TableViewSection(title: Constants.companySectionHeader.rawValue,
                                   rows: [companyInfoRow(from: companyInfo)])
    updateSection(section)
  }

  private func companyInfoRow(from companyInfo: CompanyInfo) -> ValueRow<CompanyInfoViewModel> {
    let companyInfoViewModel = CompanyInfoViewModel(companyInfo: companyInfo)
    let row = ValueRow<CompanyInfoViewModel>()
    row.value = companyInfoViewModel
    return row
  }

  private func fetchLaunches() {
    LaunchesService().fetchLaunches { result in
      switch result {
      case .success(let launches):
        self.configureLaunchesSection(from: launches)
        self.configureFilter()
        self.showLaunches()
      case .failure(_):
        self.showError()
      }
    }
  }

  private func configureLaunchesSection(from launches: [Launch]) {
    let launchViewModels = launches.compactMap { LaunchViewModel(launch: $0) }
    launchesSection = TableViewSection(title: Constants.launchesSectionHeader.rawValue,
                                       rows: launchRows(from: launchViewModels))
    updateSection(launchesSection)
    self.launchViewModels = launchViewModels
  }

  private func launchRows(from launchViewModels: [LaunchViewModel]) -> [ValueRow<LaunchViewModel>] {
    return launchViewModels.compactMap { launchViewModel in
      let launchRow = ValueRow<LaunchViewModel>()
      launchRow.value = launchViewModel
      return launchRow
    }
  }

  private func showLoading() {
    stateView.configure(.loading)
  }

  private func showError() {
    stateView.configure(.error)
  }

  private func showLaunches() {
    stateView.isHidden = true
  }

  private func configureFilter() {
    let image = UIImage(systemName: Constants.filterSymbol.rawValue)
    navigationItem.rightBarButtonItem = .init(image: image,
                                              style: .plain,
                                              target: self,
                                              action: #selector(showFilter))
    navigationItem.rightBarButtonItem?.accessibilityIdentifier = Constants.filterButtonAccessibilityIdentifier.rawValue
  }

  @objc private func showFilter() {
    guard let viewController = filterLaunchesViewController() else { return }
    viewController.updateLaunches = { self.updateLaunchesSection(with: $0) }
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.tintColor = .black
    present(navigationController, animated: true)
  }

  private func filterLaunchesViewController() -> FilterLaunchesViewController? {
    guard let launchViewModels = launchViewModels else { return nil }
    return storyboard?.instantiateViewController(identifier: FilterLaunchesViewController.identifier,
                                                 creator: { coder -> FilterLaunchesViewController? in
      FilterLaunchesViewController(coder: coder, launchViewModels: launchViewModels)
                                                 })
  }

  private func updateLaunchesSection(with launchViewModels: [LaunchViewModel]) {
    launchesSection?.updateRows(launchRows(from: launchViewModels))
    sections.remove(at: sections.count - 1)
    updateSection(launchesSection)
    scrollToTop()
  }

  private func updateSection(_ section: TableViewSection?) {
    guard let section = section else { return }
    sections.insert(section, at: sections.count)
    launchesTableView.reloadData()
  }

  private func scrollToTop() {
    launchesTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                  at: .top,
                                  animated: false)
  }
  
}

extension LaunchesViewController: UITableViewDataSource {

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
    let cellConfigurator = LaunchesCellConfigurator(tableView: tableView,
                                                    sections: sections,
                                                    indexPath: indexPath)
    return cellConfigurator.cell()
  }

}

extension LaunchesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<LaunchViewModel>,
          let launchViewModel = row.value,
          let viewController = linkOptionsViewController(launchViewModel: launchViewModel) else { return }
    let activityViewController = ActivityViewController(childViewController: viewController)
    let cell = tableView.cellForRow(at: indexPath)
    activityViewController.popoverPresentationController?.sourceView = cell
    present(activityViewController, animated: true)
  }

  private func linkOptionsViewController(launchViewModel: LaunchViewModel) -> LinkOptionsViewController? {
    storyboard?.instantiateViewController(identifier: LinkOptionsViewController.identifier,
                                          creator: { coder -> LinkOptionsViewController? in
      LinkOptionsViewController(coder: coder, launchViewModel: launchViewModel)
                                          })
  }

}

private extension LaunchesViewController {
  enum Constants: String {
    case title = "SpaceX"
    case companySectionHeader = "COMPANY"
    case launchesSectionHeader = "LAUNCHES"
    case filterSymbol = "line.horizontal.3.decrease.circle"
    case filterButtonAccessibilityIdentifier = "FilterButton"
  }
}
