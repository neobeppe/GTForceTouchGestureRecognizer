// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GTForceTouchGestureRecognizer",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "GTForceTouchGestureRecognizer",
            targets: ["GTForceTouchGestureRecognizer"]
        )
    ],
    targets: [
        .target(
            name: "GTForceTouchGestureRecognizer",
            path: "Sources",
            sources: [
                "."
            ]
        )
    ]
)
