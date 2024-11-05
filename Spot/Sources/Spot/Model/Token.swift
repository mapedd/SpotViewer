import Foundation

public struct Token: Codable, Sendable {
  public var name: String
  public var symbol: String
  public var price: Double
  public var logoURI: URL
  public var lastTradeUnixTime: Date
}
