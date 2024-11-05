import OSLog
import HTTPTypes

enum FetcherError: Error {
  case invalidURL
}

struct Fetcher {
  
  private let host: String
  private let scheme: String
  private let urlSession: URLLoading
  
  private let decoder = JSONDecoder()
  private let logger = Logger(subsystem: "com.spot.viewer", category: "networking")
  
  init(
    host: String,
    scheme: String,
    urlSession: any URLLoading
  ) {
    self.host = host
    self.scheme = scheme
    self.urlSession = urlSession
    
    decoder.dateDecodingStrategy = .secondsSince1970
  }
  
  private func makeURL(
    endpoint: Endpoint
  ) throws -> URL {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path += "/\(endpoint.path())"
    guard let url = components.url else {
      logger.error("failed to create url from components: \(components)")
      throw FetcherError.invalidURL
    }
    return url
  }
  
  private func makeURLRequest(
    url: URL,
    endpoint: Endpoint,
    httpMethod: HTTPRequest.Method
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    // for POST etc we would attach body data below
    logger.info("request created: \(request)")
    return request
  }
  
  private func makeGet(endpoint: Endpoint) throws -> URLRequest {
    let url = try makeURL(endpoint: endpoint)
    return makeURLRequest(url: url, endpoint: endpoint, httpMethod: .get)
  }
  
  public func get<Entity: Decodable>(endpoint: Endpoint) async throws
  -> Entity
  {
    try await makeEntityRequest(endpoint: endpoint, method: .get)
  }
  
  private func makeEntityRequest<Entity: Decodable>(
    endpoint: Endpoint,
    method: HTTPRequest.Method
  ) async throws -> Entity {
    let url = try makeURL(endpoint: endpoint)
    let request = makeURLRequest(url: url, endpoint: endpoint, httpMethod: method)
    logger.log(level: .info, "starting \(request)")
    let (data, _) = try await urlSession.data(for: request)
    logger.log(level: .info, "finished \(request)")
    return try decoder.decode(Entity.self, from: data)
  }
}

extension Fetcher: TokenFetcher {
  func fetchTokens() async throws -> TokenResponse {
    try await get(endpoint: TokenListEndpoint())
  }
}
