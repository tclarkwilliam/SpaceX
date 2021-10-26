//
//  LaunchesFilterApplicator.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

class LaunchesFilterApplicator {

  private var filteredLaunchViewModels: [LaunchViewModel]
  private let filteredRows: [TableRow]
  private let launchViewModels: [LaunchViewModel]

  init(filteredRows: [TableRow],
       launchViewModels: [LaunchViewModel]) {
    self.filteredRows = filteredRows
    self.launchViewModels = launchViewModels
    filteredLaunchViewModels = launchViewModels
  }

  func filteredLaunches() -> [LaunchViewModel] {
    filterLaunchOutcome()
    filterLaunchYears()
    filterLaunchOrder()
    return filteredLaunchViewModels
  }

  private func filterLaunchOutcome() {
    if let outcomeRow: LaunchOutcomeTableRow = rows()?.first {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { $0.isLaunchSuccessful == outcomeRow.isLaunchSuccessful }
    }
  }

  private func filterLaunchYears() {
    if let launchYears: [LaunchYearTableRow] = rows(), !launchYears.isEmpty {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { filtered in launchYears.contains(where: { $0.year == filtered.launchYear }) }
    }
  }

  private func filterLaunchOrder() {
    if let orderRow: LaunchOrderTableRow = rows()?.first {
      filteredLaunchViewModels.sort { orderRow.isAscending ? $0.launchYear < $1.launchYear : $0.launchYear > $1.launchYear }
    }
  }

  private func rows<T: TableRow>() -> [T]? {
    filteredRows.filter { $0 is T } as? [T]
  }

}
