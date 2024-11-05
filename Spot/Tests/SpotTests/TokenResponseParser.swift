import Testing
import Foundation
@testable import Spot

@Suite("TokenResponse JSON parsing")
struct TokenResponseParser{
  @Test("Validate parsing collection of tokens")
  func exampleParse() async throws {
    let data = try TestData.testData("data")
    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
    #expect(tokenResponse.tokens.count == 5)
  }
}
