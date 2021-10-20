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
    filterSort()
    return filteredLaunchViewModels
  }

  private func filterLaunchOutcome() {
    let outcomeRows: [LaunchOutcomeTableRow]? = rows()
    if let outcomeRow = outcomeRows?.first {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { $0.isLaunchSuccessful == outcomeRow.isLaunchSuccessful }
    }
  }

  private func filterLaunchYears() {
    let launchYears: [LaunchYearTableRow]? = rows()
    if let launchYears = launchYears, !launchYears.isEmpty {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { filtered in launchYears.contains(where: { $0.year == filtered.launchYear }) }
    }
  }

  private func filterSort() {
    let sortRows: [SortTableRow]? = rows()
    if let sortRow = sortRows?.first {
      filteredLaunchViewModels.sort { sortRow.isAscending ? $0.launchYear < $1.launchYear : $0.launchYear > $1.launchYear }
    }
  }

  private func rows<T: TableRow>() -> [T]? {
    filteredRows.filter { $0 is T } as? [T]
  }

}
