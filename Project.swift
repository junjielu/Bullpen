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
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
                "ITSAppUsesNonExemptEncryption": false,
            ]),
            sources: ["Bullpen/Sources/**"],
            resources: ["Bullpen/Resources/**"],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "Z9EB9XJ383",
                    "CODE_SIGN_STYLE": "Automatic",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                ]
            )
        ),
    ]
)
