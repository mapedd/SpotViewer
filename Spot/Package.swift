// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension [Resource] {
  static let testResources: [Resource] = [
    .copy("data.json"),
    .copy("data_single.json")
  ]
}

extension [SwiftSetting] {
  static let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("ExistentialAny"),
    .swiftLanguageMode(.v6)
  ]
}

let package = Package(
  name: "Spot",
  platforms: [.iOS(.v18)],
  products: [
    .library(
      name: "Spot",
      targets: ["Spot"]
    ),
    .library(
      name: "SpotUI",
      targets: ["SpotUI"]
    ),
    .library(
      name: "SpotTestData",
      targets: ["SpotTestData"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.1.2"),
    .package(url: "https://github.com/apple/swift-http-types.git", branch: "main")
  ],
  targets: [
    .target(
      name: "Spot",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types")
      ],
      swiftSettings: .swiftSettings
    ),
    .target(
      name: "SpotTestData",
      dependencies: [],
      resources: .testResources
    ),
    .target(
      name: "SpotUI",
      dependencies: [
        "Spot",
        .product(name: "SDWebImageSwiftUI", package: "sdwebimageswiftui")
      ],
      swiftSettings: .swiftSettings
    ),
    .testTarget(
      name: "SpotTests",
      dependencies: ["Spot", "SpotTestData"]
    ),
    .testTarget(
      name: "SpotUITests",
      dependencies: ["Spot", "SpotUI", "SpotTestData"]
    )
  ]
)
