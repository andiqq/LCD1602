// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyLCD",
   
    dependencies: [
       // .package(name: "SwiftyGPIO", path: "/home/andreas/IoT/swift/SwiftyGPIO")
       .package(url: "https://github.com/andiqq/SwiftyGPIO.git", from: "1.0.2")
    ],
    targets: [
        .executableTarget(
            name: "SwiftyLCD",
            dependencies: [
                .product(name: "SwiftyGPIO", package: "SwiftyGPIO")
            ]),
    ]
)
