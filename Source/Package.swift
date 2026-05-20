// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TermiPetApp",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "TermiPet", targets: ["TermiPet"]),
    ],
    targets: [
        .target(
            name: "TermiPetCore"
        ),
        .executableTarget(
            name: "TermiPet",
            dependencies: ["TermiPetCore"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TermiPetTests",
            dependencies: ["TermiPetCore", "TermiPet"]
        ),
    ]
)
