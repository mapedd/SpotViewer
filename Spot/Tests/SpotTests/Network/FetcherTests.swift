@testable import Spot
import Testing
import Foundation
import SpotTestData

@Suite("Fetcher tests")
struct FetcherTests {
  
  func sut(_ output: MockURLLoading.Output) -> Fetcher {
    .init(
      host: "stot.dog",
      scheme: "https",
      urlSession: MockURLLoading(output:output)
    )
  }
  
  @Test("Fetch and parse a mock entity")
  func loadMockData() async throws {
    let fetcher = sut(.validMockData(.mock))
    let data: MockEntity = try await fetcher.get(endpoint: MockEndpoint())
    #expect(data == .mock)
  }
  
  @Test("Fetch and parse a Token entity")
  func loadTokenData() async throws {
    let data = try TestData.token.data()
    let fetcher = sut(.validTestData(data))
    let token: Token = try await fetcher.get(endpoint: MockEndpoint())
    #expect(token.name == "Orca")
  }
  
  @Test("Error while fetching")
  func loadAndReceiveError() async throws {
    enum MockError: Error, Equatable {
      case someError
    }
    let fetcher = sut(.error(MockError.someError))
    try await #require(throws: MockError.someError, performing: {
      let _: MockEntity = try await fetcher.get(endpoint: MockEndpoint())
    })
  }
}

struct MockEntity:Equatable, Codable {
  var title: String
  var date: Date
  
  static let mock = MockEntity(
    title: "mockTitle",
    date: Date(timeIntervalSince1970: 1730803401)
  )
}

struct MockEndpoint: Endpoint {
  func path() -> String {
    "mock-path"
  }
}

final class MockURLLoading: URLLoading {
  enum Output {
    case error(any Error)
    case validMockData(MockEntity)
    case validTestData(Data)
  }
  let output: Output
  let encoder: JSONEncoder
  init (output: Output) {
    self.output = output
    self.encoder = JSONEncoder()
    self.encoder.dateEncodingStrategy = .secondsSince1970
  }
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    
    switch output {
    case .error(let error):
      throw error
    case .validMockData(let entity):
      let data = try encoder.encode(entity)
      // safe to force cast https://forums.developer.apple.com/forums/thread/120099
      return (data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    case .validTestData(let data):
      return (data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
  }
}
