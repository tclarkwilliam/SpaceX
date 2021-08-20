//
//  LaunchesErrorView.swift
//  SpaceX
//
//  Created by Tom on 19/08/2021.
//

import SwiftUI

struct LaunchesErrorView: View {
  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: "exclamationmark.icloud")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
      Text("Unable to load launches")
    }
  }
}
