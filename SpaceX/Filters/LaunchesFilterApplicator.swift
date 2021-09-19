//
//  LaunchesFilterApplicator.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

class LaunchesFilterApplicator {

  private let filters: [TableRow]
  private let launchViewModels: [LaunchViewModel]

  init(filters: [TableRow],
       launchViewModels: [LaunchViewModel]) {
    self.filters = filters
    self.launchViewModels = launchViewModels
  }

  func apply() -> [LaunchViewModel] {
    var filteredLaunchViewModels = launchViewModels
    if let launchOutcome = launchOutcome() {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { $0.isLaunchSuccessful == launchOutcome.isSuccess }
    }
    if let launchYears = launchYears(), !launchYears.isEmpty {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { launchYears.contains($0.launchYear) }
    }
    if let sortOrder = sortOrder() {
      filteredLaunchViewModels.sort { sortOrder.isAscending ? $0.launchYear < $1.launchYear : $0.launchYear > $1.launchYear }
    }
    return filters.isEmpty ? launchViewModels : filteredLaunchViewModels
  }

  private func launchOutcome() -> LaunchOutcome? {
    let outcomeRows = filters.filter { $0 is LaunchOutcomeTableRow } as? [LaunchOutcomeTableRow]
    return outcomeRows?.compactMap { $0.launchOutcome }.first
  }

  private func launchYears() -> [Int]? {
    let yearRows = filters.filter { $0 is LaunchYearTableRow } as? [LaunchYearTableRow]
    return yearRows?.compactMap { $0.launchYear }
  }

  private func sortOrder() -> SortOrder? {
    let sortRows = filters.filter { $0 is SortTableRow } as? [SortTableRow]
    return sortRows?.compactMap { $0.sortOrder }.first
  }

}
