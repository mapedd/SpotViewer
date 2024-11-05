import Testing
import Foundation
@testable import Spot

@Suite("Token JSON parsing")
struct Test {
  @Test("Validate parsing of all properties")
  func testParsingSingleToken() async throws {
    let data = try TestData.testData("data_single")
    let token = try JSONDecoder().decode(Token.self, from: data)
    #expect(token.name == "Orca")
    #expect(token.symbol == "ORCA")
    #expect(token.logoURI == URL(string: "https://logo.png")!)
    #expect(token.price == 2.934265673887287)
  }
}
