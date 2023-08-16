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
    .package(path: "../Decoy")
  ],
  targets: [
    .target(
      name: "DecoyXCUI",
      dependencies: ["Decoy"]
    )
  ]
)
