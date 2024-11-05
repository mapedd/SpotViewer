import Spot

extension TokenListViewModel {
  public static func makeViewModel() -> TokenListViewModel {
    .init(
      fetcher: TokenFetching.defaultFetcher(),
      mapper: TokenRowMapper(
        currencyCode: .usd,
        locale: .autoupdatingCurrent
      )
    )
  }
}
