//
//  Cache.swift
//  SpaceX
//
//  Created by Tom on 15/05/2021.
//

import Foundation

class Cache<V> where V: Codable {

  private let fileManager: FileManager
  private let directory: CacheDirectory

  init(fileManager: FileManager = FileManager.default,
       directory: CacheDirectory) {
    self.fileManager = fileManager
    self.directory = directory
  }

  func save(_ value: V,
            path: String) {
    guard let fileURL = directoryURL?.appendingPathComponent(path) else { return }
    try? JSONEncoder().encode(value).write(to: fileURL)
  }

  func retrieve(_ path: String) -> V? {
    guard let fileURL = directoryURL?.appendingPathComponent(path),
          let data = try? Data(contentsOf: fileURL) else { return nil }
    return try? JSONDecoder().decode(V.self, from: data)
  }

  func clear() {
    guard let directoryURL = directoryURL else { return }
    try? fileManager.removeItem(at: directoryURL)
  }

  private var directoryURL: URL? {
    guard let cachesDirectoryURL = fileManager.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first else { return nil }
    let directoryURL = cachesDirectoryURL.appendingPathComponent(directory.rawValue)
    if !fileManager.fileExists(atPath: directoryURL.path) {
      do {
        try fileManager.createDirectory(at: directoryURL,
                                        withIntermediateDirectories: false,
                                        attributes: nil)
      } catch {
        return nil
      }
    }
    return directoryURL
  }

}
