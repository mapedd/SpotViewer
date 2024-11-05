import Foundation
import Spot

public enum CurrencyCode: String {
  case usd = "USD"
}

public protocol TokenRowMapping {
  func mapToRow(token: Token) -> TokenRow
}

public struct TokenRowMapper: TokenRowMapping {
  var currencyCode: CurrencyCode
  var locale: Locale
  
  public func mapToRow(token: Token) -> TokenRow {
    TokenRow(
      imageURL: token.logoURI,
      name: token.name.isEmpty ? "N/A" : token.name,
      symbol: tokenConversion(token, currencyCode),
      price: tokenPrice(token, locale),
      lastTradeDate: token.lastTradeUnixTime
        .formatted(.dateTime.locale(locale))
    )
  }
  
  func tokenPrice(_ token: Token, _ locale: Locale) -> String {
    // for smaller < 0.01 show at least some digits instead of 0.00
    let fractionDigits: Int = if token.price < 0.01 {
      6
    } else {
    2
    }
    return token.price.formatted(
      .currency(code:currencyCode.rawValue).precision(.fractionLength(fractionDigits))
      .locale(locale)
    )
  }
  
  func tokenConversion(_ token: Token, _ currencyCode: CurrencyCode) -> String {
    "\(tokenSymbol(token)) → \(currencyCode.rawValue)"
  }
  
  func tokenSymbol(_ token: Token) -> String {
    token.symbol.isEmpty ? "N/A" : token.symbol
  }
}
