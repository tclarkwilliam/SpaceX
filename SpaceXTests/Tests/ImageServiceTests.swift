//
//  ImageServiceTests.swift
//  SpaceXTests
//
//  Created by Tom on 16/05/2021.
//

import XCTest

@testable import SpaceX

class ImageServiceTests: XCTestCase {

  private var mockService: MockService!
  private var mockCache: MockCache!
  private let imagePath = "https://test/image.png"
  private let imageData = UIImage(systemName: "xmark")!.pngData()!

  override func setUp() {
    super.setUp()
    mockService = MockService()
    mockCache = MockCache(directory: .images)
  }

  override func tearDown() {
    mockService = nil
    mockCache = nil
    super.tearDown()
  }

  func test_fetchMissionImage_success_returnsImage() {
    mockService.data = imageData
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { result in
      guard case .success(let image) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(image)
    }
  }

  func test_fetchMissionImage_failure_returnsError() {
    mockService.data = nil
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
  }

  func test_fetchMissionImage_invalidURL_returnsError() {
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: "")
    subject.fetchMissionImage() { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertNotNil(error)
    }
  }

  func test_fetchMissionImage_cacheEmpty_savesImageToCache() {
    mockService.data = imageData
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { _ in
      XCTAssertTrue(self.mockCache.savedCalled)
    }
  }

  func test_fetchMissionImage_cacheNotEmpty_retrievesImageFromCache() {
    mockCache.cachedImage = CachedImage(data: imageData)
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { _ in
      XCTAssertNotNil(self.mockCache.cachedImage)
    }
  }

}
