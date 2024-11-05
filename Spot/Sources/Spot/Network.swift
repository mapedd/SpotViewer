import Foundation

public enum TokenFetching {
  public static func defaultFetcher() -> some TokenFetcher {
    Fetcher(
      host: host(),
      scheme: "https",
      urlSession: URLSession.shared
    )
  }
}
