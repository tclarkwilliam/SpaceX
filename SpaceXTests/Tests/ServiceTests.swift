//
//  ServiceTests.swift
//  SpaceXTests
//
//  Created by Tom on 10/05/2021.
//

import XCTest

@testable import SpaceX

class ServiceTests: XCTestCase {

  private var stubbedSession: StubbedSession!

  override func setUp() {
    super.setUp()
    stubbedSession = StubbedSession()
  }

  override func tearDown() {
    stubbedSession = nil
    super.tearDown()
  }

  func test_fetch_success_returnsDecodedData() {
    let expectation = expectation(description: "Fetch with success")
    let dataDict = dataDictionary(isValidData: true)
    stubbedSession.data = try? JSONSerialization.data(withJSONObject: dataDict, options: [])
    let subject = Service(session: stubbedSession)
    let stubbedURL = URL(string: "www.test.com")!
    subject.fetch(url: stubbedURL) { (result: Result<DecodableData, ServiceError>) in
      guard case .success(let companyInfo) = result else { return XCTFail("Result should be success") }
      XCTAssertNotNil(companyInfo)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetch_failure_returnsError() {
    let expectation = expectation(description: "Fetch with decoding error")
    let stubbedError = NSError(domain: "", code: 1, userInfo: [:])
    stubbedSession.error = stubbedError
    let subject = Service(session: stubbedSession)
    let stubbedURL = URL(string: "www.test.com")!
    subject.fetch(url: stubbedURL) { (result: Result<DecodableData, ServiceError>) in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .error(stubbedError))
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetch_decodingError_returnsDecodingError() {
    let expectation = expectation(description: "Fetch with error")
    let dataDict = dataDictionary(isValidData: false)
    stubbedSession.data = try? JSONSerialization.data(withJSONObject: dataDict, options: [])
    let subject = Service(session: stubbedSession)
    let stubbedURL = URL(string: "www.test.com")!
    subject.fetch(url: stubbedURL) { (result: Result<DecodableData, ServiceError>) in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .decoding)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetch_invalidData_returnsInvalidDataError() {
    let expectation = expectation(description: "Fetch with invalid data")
    stubbedSession.data = nil
    let subject = Service(session: stubbedSession)
    let stubbedURL = URL(string: "www.test.com")!
    subject.fetch(url: stubbedURL) { (result: Result<DecodableData, ServiceError>) in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidData)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func test_fetch_invalidURL_returnsInvalidURLError() {
    let expectation = expectation(description: "Fetch with invalid URL")
    let subject = Service(session: stubbedSession)
    subject.fetch(url: nil) { (result: Result<DecodableData, ServiceError>) in
      guard case .failure(let error) = result else { return XCTFail("Result should be failure") }
      XCTAssertTrue(error == .invalidURL)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  private func dataDictionary(isValidData: Bool) -> [String: Any] {
    ["name": "Name",
     "age": isValidData ? 1 : "1",
     "date": "2006-03-25T10:30:00+12:00"]
  }

}

private struct DecodableData: Decodable {
  let name: String
  let age: Int
  let date: Date
}
