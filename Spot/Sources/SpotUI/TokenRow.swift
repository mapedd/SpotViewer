import Foundation

public struct TokenRow: Identifiable, Sendable, Equatable {
  public var id: String {
    // assuming that symbol is unique in the backend
    symbol
  }
  public var imageURL: URL
  public var name: String
  public var symbol: String
  public var price: String
  public var lastTradeDate: String
}

extension TokenRow {
  static let sampleData: [TokenRow] = [
    TokenRow(
      imageURL: URL(string: "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/orcaEKTdK7LKz57vaAYr9QeNsVEPfiu6QeMU1kektZE/logo.png")!,
      name: "Solana",
      symbol: "SOL → USD",
      price: "$1.00",
      lastTradeDate: "5 March 2024"
    )
  ]
}
