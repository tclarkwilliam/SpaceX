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
    do {
      let data = try JSONEncoder().encode(value)
      try data.write(to: fileURL)
    } catch {
      print("Handle error: \(error)")
    }
  }

  var retrieve: V? {
    guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
    do {
      let data = try Data(contentsOf: fileURL)
      return try JSONDecoder().decode(V.self, from: data)
    } catch {
      print("Handle error: \(error)")
      return nil
    }
  }

  func clear() {
    try? FileManager.default.removeItem(at: folderURL)
  }

  private func createDirectory() {
    var isDirectory: ObjCBool = false
    if !FileManager.default.fileExists(atPath: folderURL.path,
                                       isDirectory: &isDirectory), !isDirectory.boolValue {
      try? FileManager.default.createDirectory(at: folderURL,
                                               withIntermediateDirectories: false)
    }
  }

  private var fileURL: URL {
    return folderURL.appendingPathComponent(filename)
  }

  private var folderURL: URL {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                   .userDomainMask,
                                                   true).first!
    return URL(fileURLWithPath: path).appendingPathComponent(directory)
  }

}

enum CachePath: String {
  case images = "co.uk.tomclark.Images"
}
