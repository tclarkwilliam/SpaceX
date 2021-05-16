//
//  ViewController.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchesViewController: UIViewController {

  @IBOutlet weak private var launchesTableView: UITableView!

  private lazy var sections = [TableViewSection]()
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
    CompanyInfoService().fetchInfo { result in
      switch result {
      case .success(let companyInfo):
        self.configureCompanyInfoSection(from: companyInfo)
        self.fetchLaunches()
      case .failure(let error):
        print("Handle error \(error)")
      }
    }
  }

  private func configureCompanyInfoSection(from companyInfo: CompanyInfo) {
    let section = TableViewSection(title: Constants.company.rawValue,
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
      case .failure(let error):
        print("Handle error \(error)")
      }
    }
  }

  private func configureLaunchesSection(from launches: [Launch]) {
    let launchViewModels = launches.compactMap { LaunchViewModel(launch: $0) }
    launchesSection = TableViewSection(title: Constants.launches.rawValue,
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

  private func configureFilter() {
    let image = UIImage(systemName: Constants.filterSymbol.rawValue)
    navigationItem.rightBarButtonItem = .init(image: image,
                                              style: .plain,
                                              target: self,
                                              action: #selector(showFilters))
  }

  @objc private func showFilters() {
    let identifier = FilterLaunchesViewController.identifier
    guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) as? FilterLaunchesViewController else { return }
    viewController.updateLaunches = { self.updateLaunchesSection(with: $0) }
    viewController.launchViewModels = launchViewModels
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.tintColor = .black
    present(navigationController, animated: true)
  }

  private func updateLaunchesSection(with launchViewModels: [LaunchViewModel]) {
    self.launchesSection?.updateRows(self.launchRows(from: launchViewModels))
    self.sections.remove(at: self.sections.count - 1)
    self.updateSection(self.launchesSection)
    let indexPath = IndexPath(row: 0, section: 0)
    self.launchesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
  }

  private func updateSection(_ section: TableViewSection?) {
    guard let section = section else { return }
    sections.insert(section, at: self.sections.count)
    launchesTableView.reloadData()
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
    if let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.identifier,
                                                for: indexPath) as? CompanyTableViewCell,
       let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<CompanyInfoViewModel>,
       let viewModel = row.value {
      cell.selectionStyle = .none
      cell.configure(viewModel: viewModel)
      return cell
    }
    if let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier,
                                                for: indexPath) as? LaunchTableViewCell,
       let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<LaunchViewModel>,
       let viewModel = row.value {
      cell.configure(viewModel: viewModel)
      return cell
    }
    //Remove this return failure cell?
    return UITableViewCell()
  }

}

extension LaunchesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<LaunchViewModel> else { return }
    presentLinkOptions(launchViewModel: row.value)
  }

  private func presentLinkOptions(launchViewModel: LaunchViewModel?) {
    guard let viewController = storyboard?.instantiateViewController(withIdentifier: LinkOptionsViewController.identifier) as? LinkOptionsViewController else { return }
    viewController.launchViewModel = launchViewModel
    let activityViewController = ActivityViewController(childViewController: viewController)
    present(activityViewController, animated: true)
  }

}

private extension LaunchesViewController {
  enum Constants: String {
    case title = "SpaceX"
    case company = "COMPANY"
    case launches = "LAUNCHES"
    case filterSymbol = "line.horizontal.3.decrease.circle"
  }
}
