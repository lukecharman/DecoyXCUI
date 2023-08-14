// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "DecoyXCUI",
  products: [
    .library(
      name: "DecoyXCUI",
      targets: ["DecoyXCUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/lukecharman/Decoy", branch: "main")
  ],
  targets: [
    .target(
      name: "DecoyXCUI",
      dependencies: ["Decoy"]
    )
  ]
)
