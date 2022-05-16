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

  private var launchViewModels: [LaunchViewModel]?
  private var companyInfoSection: TableViewSection?
  private var launchesSection: TableViewSection?
  private var tableDataSource: TableDataSource?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.title.rawValue
    registerCells()
    fetchCompanyInfo()
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
      case .failure(let error):
        self.showError(error)
      }
    }
  }

  private func configureCompanyInfoSection(from companyInfo: CompanyInfoViewModel) {
    let rows = [CompanyTableRow(viewModel: companyInfo)]
    companyInfoSection = TableViewSection(title: Constants.companySectionHeader.rawValue,
                                          rows: rows)
  }

  private func fetchLaunches() {
    LaunchesService().fetchLaunches { result in
      switch result {
      case .success(let launches):
        self.launchViewModels = launches
        self.configureLaunchesSection(with: launches)
        self.configureFilter()
        self.showLaunches()
      case .failure(let error):
        self.showError(error)
      }
    }
  }

  private func configureLaunchesSection(with launchViewModels: [LaunchViewModel]) {
    let rows = launchViewModels.compactMap { viewModel -> LaunchesTableRow? in
      let row = LaunchesTableRow(viewModel: viewModel)
      row.didSelect = { [weak self] in self?.showLinkOptions(indexPath: $0, viewModel: viewModel) }
      return row
    }
    launchesSection = TableViewSection(title: Constants.launchesSectionHeader.rawValue,
                                       rows: rows)
    configureDataSource()
  }

  private func configureDataSource() {
    guard let companyInfo = companyInfoSection,
          let launchesSection = launchesSection else { return }
    tableDataSource = TableDataSource(tableView: launchesTableView,
                                      sections: [companyInfo, launchesSection])
    launchesTableView.reloadData()
  }

  private func showLoading() {
    stateView.configure(.loading)
  }

  private func showError(_ error: ServiceError) {
    stateView.configure(.error(error))
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
    viewController.updateLaunches = { [weak self] in self?.updateLaunchesSection(with: $0) }
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
    configureLaunchesSection(with: launchViewModels)
    scrollToTop()
  }

  private func scrollToTop() {
    launchesTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                  at: .top,
                                  animated: false)
  }

  private func showLinkOptions(indexPath: IndexPath,
                               viewModel: LaunchViewModel) {
    guard let viewController = linkOptionsViewController(launchViewModel: viewModel) else { return }
    let activityViewController = ActivityViewController(childViewController: viewController)
    let cell = launchesTableView.cellForRow(at: indexPath)
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
