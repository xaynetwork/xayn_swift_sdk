// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XaynSDK",
    products: [
        .library(
            name: "XaynSDK",
            targets: ["XaynSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XaynSDK",
            dependencies: []),
    ]
)
