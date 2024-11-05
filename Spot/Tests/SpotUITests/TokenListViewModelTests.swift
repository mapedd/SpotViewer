@testable import SpotUI
@testable import Spot
import Foundation
import Testing

@MainActor
@Suite("List view model")
struct ListViewModelTests {
  
  func sut(_ scenario: MockFetcher.Scenario) -> TokenListViewModel {
    .init(
      fetcher: MockFetcher(scenario: scenario),
      currencyCode: .usd,
      mapper: MockMapper(),
      locale: Locale(identifier: "en_US")
    )
  }
  
  @Test("Initial state")
  func initialState() {
    let vm = sut(.data)
    #expect(vm.content == .initial)
  }
  @Test("Loading state")
  func loadingState() async {
    let vm = sut(.infiniteWait)
    Task {
      await vm.loadDataTask()
    }
    await Task.yield()
    #expect(vm.content == .loading)
  }
  @Test("Loaded state")
  func loadedState() async {
    let vm = sut(.data)
    await vm.loadDataTask()
    let expectedRows = [Token].sampleTokens.map { MockMapper().mapToRow(token: $0) }
    #expect(vm.content == .loaded(rows: expectedRows))
  }
  @Test("Empty state")
  func emptyState() async {
    let vm = sut(.empty)
    await vm.loadDataTask()
    #expect(vm.content == .empty)
  }
  @Test("Failed state")
  func faledState() async {
    let vm = sut(.errror)
    await vm.loadDataTask()
    #expect(vm.content == .failed(MockFetcher.MockError.someError))
  }
}

struct MockFetcher: TokenFetcher {
  enum Scenario {
    case data
    case infiniteWait
    case errror
    case empty
  }
  enum MockError: Error {
    case someError
  }
  let scenario: Scenario
  func fetchTokens() async throws -> TokenResponse {
    switch scenario {
    case .empty:
      return .init(tokens: [])
    case .data:
      return .sampleResponse
    case .infiniteWait:
      try? await Task.sleep(nanoseconds: NSEC_PER_SEC * 1000)
      return .sampleResponse
    case .errror:
      throw MockError.someError
    }
  }
}

extension ContentState: Equatable {
  public static func == (lhs: ContentState, rhs: ContentState) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty): return true
    case (.initial, .initial): return true
    case (.loading, .loading): return true
    case (.loaded(let l), .loaded(let r)): return l == r
    case (.failed, .failed): return true
    default: return false
    }
  }
}

extension TokenResponse {
  static let sampleResponse = TokenResponse(
    tokens: .sampleTokens
  )
}

extension [Token] {
  static let sampleTokens: [Token] = [
    .init(
      name: "TOKEN",
      symbol: "TKK",
      price: 123,
      logoURI: URL(string: "http://spot.dog")!,
      lastTradeUnixTime: Date(timeIntervalSince1970: 123)
    )
  ]
}

struct MockMapper: TokenRowMapping {
  func mapToRow(token: Spot.Token) -> TokenRow {
    .init(
      imageURL: URL(string: "http://spot.dog")!,
      name: token.name,
      symbol: "",
      price: "",
      lastTradeDate: ""
    )
  }
}
