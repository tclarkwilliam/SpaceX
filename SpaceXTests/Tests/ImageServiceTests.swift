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
    let expectation = expectation(description: "Fetch mission image success")
    mockService.data = imageData
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { result in
      guard case .success(let image) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(image)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchMissionImage_invalidData_returnsError() {
    let expectation = expectation(description: "Fetch mission image invalid data")
    mockService.data = nil
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidData)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchMissionImage_invalidURL_returnsError() {
    let expectation = expectation(description: "Fetch mission image invalid URL")
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: "")
    subject.fetchMissionImage() { result in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidURL)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchMissionImage_cacheEmpty_savesImageToCache() {
    let expectation = expectation(description: "Fetch mission image cache empty")
    mockService.data = imageData
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { _ in
      XCTAssertTrue(self.mockCache.savedCalled)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetchMissionImage_cacheNotEmpty_retrievesImageFromCache() {
    let expectation = expectation(description: "Fetch mission image cache not empty")
    mockCache.cachedImage = CachedImage(data: imageData)
    let subject = ImageService(service: mockService,
                               cache: mockCache,
                               path: imagePath)
    subject.fetchMissionImage() { _ in
      XCTAssertNotNil(self.mockCache.cachedImage)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
