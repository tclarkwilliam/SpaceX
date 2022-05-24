//
//  LaunchesErrorView.swift
//  SpaceX
//
//  Created by Tom on 19/08/2021.
//

import SwiftUI

struct LaunchesErrorView: View {

  private let error: ServiceError

  init(error: ServiceError) {
    self.error = error
  }
  
  var body: some View {
    VStack(spacing: 50) {
      Image(systemName: "sleep")
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 150)
      Text("Unable to load launches due to \(error.message)")
        .multilineTextAlignment(.center)
    }
  }
  
}
