// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
  ],
  dependencies: [
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.1.2"),
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.0")
  ],
  targets: [
    .target(
      name: "Spot",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types")
      ],
      swiftSettings: [
        .enableExperimentalFeature("ExistentialAny"),
        .swiftLanguageMode(.v6)
      ]
    ),
    .target(
      name: "SpotUI",
      dependencies: [
        "Spot",
        .product(name: "SDWebImageSwiftUI", package: "sdwebimageswiftui")
      ],
      swiftSettings: [
        .enableExperimentalFeature("ExistentialAny"),
        .swiftLanguageMode(.v6)
      ]
    ),
    .testTarget(
      name: "SpotTests",
      dependencies: ["Spot"],
      resources: [
        .copy("data.json"),
        .copy("data_single.json")
      ]
    ),
  ]
)
