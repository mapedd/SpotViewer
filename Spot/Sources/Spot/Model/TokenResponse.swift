import Foundation

public struct TokenResponse: Codable, Sendable {
  public var tokens: [Token]
}
