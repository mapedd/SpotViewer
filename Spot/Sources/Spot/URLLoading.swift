import Foundation

protocol URLLoading: Sendable {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession : URLLoading {
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    try await data(for: request, delegate: nil)
  }
}
