import Foundation

protocol Endpoint: Sendable {
  func path() -> String
}

struct TokenListEndpoint: Endpoint {
  func path() -> String {
    "ios-interview-api/data.json"
  }
}

func host() -> String {
  ProcessInfo.processInfo.environment["HOST"] ??
  "spot-labs.github.io"
}
