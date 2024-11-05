public protocol TokenFetcher: Sendable {
  func fetchTokens() async throws -> TokenResponse
}
