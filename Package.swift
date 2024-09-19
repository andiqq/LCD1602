// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyLCD",
    // products: [
    //     .library(
    //         name: "SwiftyLCD", 
    //         targets: ["SwiftyLCD"])
    // ],
    dependencies: [
        .package(name: "SwiftyGPIO", path: "/home/andreas/IoT/swift/SwiftyGPIO")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SwiftyLCD",
            dependencies: [
                .product(name: "SwiftyGPIO", package: "SwiftyGPIO")
            ]),
    ]
)
