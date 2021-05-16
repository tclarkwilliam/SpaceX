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
        let companyInfoViewModel = CompanyInfoViewModel(companyInfo: companyInfo)
        let row = ValueRow<CompanyInfoViewModel>()
        row.value = companyInfoViewModel
        let companySection = TableViewSection(title: Constants.company.rawValue, rows: [row])
        self.updateSection(companySection)
        self.fetchLaunches()
      case .failure(let error):
        print("Handle error \(error)")
      }
    }
  }

  private func fetchLaunches() {
    LaunchesService().fetchLaunches { result in
      switch result {
      case .success(let launches):
        let launchViewModels = launches.compactMap { LaunchViewModel(launch: $0) }
        let rows: [ValueRow<LaunchViewModel>] = launchViewModels.compactMap { vm in
          let row = ValueRow<LaunchViewModel>()
          row.value = vm
          return row
        }
        let launchesSection = TableViewSection(title: Constants.launches.rawValue, rows: rows)
        self.updateSection(launchesSection)
        self.launchViewModels = launchViewModels
        self.configureFilter()
      case .failure(let error):
        print("Handle error \(error)")
      }
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
    viewController.updateLaunches = { launchViewModels in
      //TODO: don't create new section, update viewModels
      let rows: [ValueRow<LaunchViewModel>] = launchViewModels.compactMap { vm in
        let row = ValueRow<LaunchViewModel>()
        row.value = vm
        return row
      }
      let launchesSection = TableViewSection(title: Constants.launches.rawValue, rows: rows)
      self.sections.remove(at: 1)
      self.updateSection(launchesSection)
      let indexPath = IndexPath(row: 0, section: 0)
      self.launchesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    viewController.launchViewModels = launchViewModels
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.tintColor = .black
    present(navigationController, animated: true)
  }

  private func updateSection(_ section: TableViewSection) {
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
    if let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.identifier, for: indexPath) as? CompanyTableViewCell,
       let row = sections[indexPath.section].rows[indexPath.row] as? ValueRow<CompanyInfoViewModel>,
       let viewModel = row.value {
      cell.selectionStyle = .none
      cell.configure(viewModel: viewModel)
      return cell
    } else if let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier, for: indexPath) as? LaunchTableViewCell,
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
