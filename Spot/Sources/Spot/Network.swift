import Foundation

// Public access point to get the propertly configured fetcher
public enum TokenFetching {
  public static func defaultFetcher() -> some TokenFetcher {
    Fetcher(
      host: host(),
      scheme: "https",
      urlSession: URLSession.shared
    )
  }
}
