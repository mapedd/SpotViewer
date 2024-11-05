import Foundation

enum TestData {
  
  enum ReadError: Error {
    case fileNotFound
  }
  
  static func testData(_ file: String, extension: String = "json") throws  -> Data {
    guard
      let url = Bundle.module.url(forResource: file, withExtension: `extension`)
    else {
      throw ReadError.fileNotFound
    }
    return try Data(contentsOf: url)
  }
}
