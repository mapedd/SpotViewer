import Spot
import Observation
import OSLog
import Foundation

public enum ContentState {
  case initial
  case loading
  case empty
  case failed(any Error)
  case loaded(rows: [TokenRow])
}

@MainActor
@Observable
public class TokenListViewModel: TokenListViewModelProtocol {
  private let fetcher: any TokenFetcher
  private let mapper: TokenRowMapper
  private let logger = Logger(subsystem: "com.spot.viewer", category: "tokenList")
  
  public init(
    fetcher: some TokenFetcher,
    currencyCode: CurrencyCode,
    locale: Locale
  ) {
    self.fetcher = fetcher
    self.mapper = TokenRowMapper(
      currencyCode: currencyCode,
      locale: locale
    )
  }
  
  public private(set) var content: ContentState = .initial
  
  public func loadDataTask() async {
    logger.info("load requested")
    switch content {
    case .initial:
      logger.info("initial state, loadin requested")
      await loadData()
    case .loading:
      logger.info("Loading in progress")
    case .failed:
      logger.info("failed state, reload requested")
      await loadData()
    case .loaded:
      logger.info("loaded state, reload requested")
      await loadData()
    case .empty:
      logger.info("empty state, reload requested")
      await loadData()
    }
  }
  
  private func loadData() async {
    do {
      let response = try await fetcher.fetchTokens()
      let rows = response.tokens.map(mapper.mapToRow)
      if rows.isEmpty {
        logger.warning("no data recevied")
        content = .empty
      } else {
        logger.info("valid data recevied")
        content = .loaded(rows: rows)
      }
    } catch {
      logger.error("loading failed \(error.localizedDescription)")
      content = .failed(error)
    }
  }
}
