//
//  LaunchesFilterApplicator.swift
//  SpaceX
//
//  Created by Tom on 13/05/2021.
//

class LaunchesFilterApplicator {

  private let filters: [Row]
  private let launchViewModels: [LaunchViewModel]

  init(filters: [Row],
       launchViewModels: [LaunchViewModel]) {
    self.filters = filters
    self.launchViewModels = launchViewModels
  }

  func apply() -> [LaunchViewModel] {
    var filteredLaunchViewModels = launchViewModels
    if let launchOutcome = launchOutcome {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { $0.isLaunchSuccessful == launchOutcome.isSuccess }
    }
    if let filteredLaunchYears = filteredLaunchYears, !filteredLaunchYears.isEmpty {
      filteredLaunchViewModels = filteredLaunchViewModels.filter { filteredLaunchYears.contains($0.launchYear) }
    }
    if let filteredSortOrder = filteredSortOrder {
      filteredLaunchViewModels.sort { filteredSortOrder.isAscending ? $0.launchYear < $1.launchYear : $0.launchYear > $1.launchYear }
    }
    return filters.isEmpty ? launchViewModels : filteredLaunchViewModels
  }

  private var launchOutcome: LaunchOutcome? {
    let launchRows = filters.filter { $0 is ValueRow<LaunchOutcome> } as? [ValueRow<LaunchOutcome>]
    return launchRows?.compactMap { $0.value }.first
  }

  private var filteredLaunchYears: [Int]? {
    let launchYearsRows = filters.filter { $0 is ValueRow<Int> } as? [ValueRow<Int>]
    return launchYearsRows?.compactMap { $0.value }
  }

  private var filteredSortOrder: SortOrder? {
    let sortOrderRows = filters.filter { $0 is ValueRow<SortOrder> } as? [ValueRow<SortOrder>]
    return sortOrderRows?.compactMap { $0.value }.first
  }

}
