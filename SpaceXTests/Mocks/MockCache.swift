//
//  MockCache.swift
//  SpaceXTests
//
//  Created by Tom on 16/05/2021.
//

@testable import SpaceX

class MockCache: Cache<CachedImage> {

  var savedCalled: Bool = false

  override func save(_ value: CachedImage) {
    savedCalled = true
  }

  var cachedImage: CachedImage?
  
  override var retrieve: CachedImage? {
    cachedImage
  }

}
