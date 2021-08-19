//
//  Cache.swift
//  SpaceX
//
//  Created by Tom on 15/05/2021.
//

import Foundation

class Cache<V> where V: Codable {

  private let directory: String
  private let filename: String

  init(directory: String,
       filename: String = "") {
    self.directory = directory
    self.filename = filename
    createDirectory()
  }

  func save(_ value: V) {
    guard let fileURL = fileURL else { return }
    let data = try? JSONEncoder().encode(value)
    try? data?.write(to: fileURL)
  }

  var retrieve: V? {
    guard let fileURL = fileURL else { return nil }
    guard FileManager.default.fileExists(atPath: fileURL.path),
          let data = try? Data(contentsOf: fileURL) else { return nil }
    return try? JSONDecoder().decode(V.self, from: data)
  }

  func clear() {
    guard let folderURL = folderURL else { return }
    try? FileManager.default.removeItem(at: folderURL)
  }

  private func createDirectory() {
    guard let folderURL = folderURL else { return }
    var isDirectory: ObjCBool = false
    if !FileManager.default.fileExists(atPath: folderURL.path,
                                       isDirectory: &isDirectory), !isDirectory.boolValue {
      try? FileManager.default.createDirectory(at: folderURL,
                                               withIntermediateDirectories: false)
    }
  }

  private var fileURL: URL? {
    return folderURL?.appendingPathComponent(filename)
  }

  private var folderURL: URL? {
    guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                   .userDomainMask,
                                                   true).first else { return nil }
    return URL(fileURLWithPath: path).appendingPathComponent(directory)
  }

}

enum CachePath: String {
  case images = "Images"
}
