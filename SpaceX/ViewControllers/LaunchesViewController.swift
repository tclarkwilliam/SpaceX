//
//  ViewController.swift
//  SpaceX
//
//  Created by Tom on 06/05/2021.
//

import UIKit

class LaunchesViewController: UIViewController {

  private enum Constants: String {
    case title = "SpaceX"
  }

  @IBOutlet weak var launchesTableView: UITableView!

  private var sections = [LaunchesSectionable]()
  
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
        let companySection = CompanySection(companyInfoViewModel: companyInfoViewModel)
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
        let launchesSection = LaunchesSection(launchViewModels: launchViewModels)
        self.updateSection(launchesSection)
      case .failure(let error):
        print("Handle error \(error)")
      }
    }
  }

  private func updateSection(_ section: LaunchesSectionable) {
    sections.insert(section, at: self.sections.count)
    launchesTableView.reloadData()
  }
  
}

extension LaunchesViewController: UITableViewDelegate {}

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
//    //Add some sort of factory that returns cell based on section
    if let companySection = sections[indexPath.section] as? CompanySection,
       let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.identifier, for: indexPath) as? CompanyTableViewCell {
      cell.configure(viewModel: companySection.companyInfoViewModel)
      return cell
    } else if let launchesSection = sections[indexPath.section] as? LaunchesSection,
              let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier, for: indexPath) as? LaunchTableViewCell {
      cell.configure(viewModel: launchesSection.launchViewModels[indexPath.row])
      return cell
    }
    //Remove this return failure cell?
    return UITableViewCell()
  }

}
