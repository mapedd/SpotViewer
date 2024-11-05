import Foundation

public enum TestData: String {
  
  case token = "data_single"
  case tokenCollection = "data"
  
  public enum ReadError: Error {
    case fileNotFound
  }
  
  public func data() throws  -> Data {
    try Self.data(self.rawValue)
  }
  
  public static func data(_ file: String, extension: String = "json") throws  -> Data {
    guard
      let url = Bundle.module.url(forResource: file, withExtension: `extension`)
    else {
      throw ReadError.fileNotFound
    }
    return try Data(contentsOf: url)
  }
}
