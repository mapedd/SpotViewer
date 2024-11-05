import Foundation
@testable import SpotUI
@testable import Spot
import Testing

@Suite("Token Row Mapper")
struct TokenRowMapperTests {
  func sut() -> TokenRowMapper {
    .init(
      currencyCode: .usd,
      locale: Locale(identifier: "en_US")
    )
  }
  @Test("Name Mapping")
  func mapName() async throws {
    let mapper = sut()
    #expect(mapper.mapToRow(token: .testToken).name == "NAME")
  }
  
  @Test("Symbol Mapping")
  func symbol() async throws {
    let mapper = sut()
    #expect(mapper.mapToRow(token: .testToken).symbol == "SYMBOL → USD")
  }
  
  @Test("Price Mapping")
  func price() async throws {
    let mapper = sut()
    #expect(mapper.mapToRow(token: .testToken).price == "$12.34")
  }
  
  @Test("Price Mapping very small")
  func priceSmall() async throws {
    let mapper = sut()
    var token = Token.testToken
    token.price = 0.000001
    #expect(mapper.mapToRow(token: token).price == "$0.000001")
  }
  
  @Test("Date Mapping")
  func date() async throws {
    let mapper = sut()
    #expect(mapper.mapToRow(token: .testToken).lastTradeDate == "11/5/2024, 1:08 PM")
  }
  
  @Test("Image Link Mapping")
  func imageLink() async throws {
    let mapper = sut()
    #expect(mapper.mapToRow(token: .testToken).imageURL == URL(string: "http://spot.dog")!)
  }
}

extension Token {
  static let testToken = Token(
    name: "NAME",
    symbol: "SYMBOL",
    price: 12.34,
    logoURI: URL(string: "http://spot.dog")!,
    lastTradeUnixTime: Date(timeIntervalSince1970: 1730808502)
  )
}
