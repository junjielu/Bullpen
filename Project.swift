import ProjectDescription

let project = Project(
    name: "Bullpen",
    targets: [
        .target(
            name: "Bullpen",
            destinations: .iOS,
            product: .app,
            bundleId: "com.bullpen.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Bullpen/Sources/**"],
            resources: ["Bullpen/Resources/**"]
        ),
    ]
)
