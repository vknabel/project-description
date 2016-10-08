import PackageDescription

let package = Package(
    name: "ProjectDescription",
    targets: [
        Target(name: "ProjectDescription"),
        Target(name: "CocoapodsProject", dependencies: [
            .Target(name: "ProjectDescription")
        ]),
        Target(name: "GitProject", dependencies: [
            .Target(name: "ProjectDescription")
        ]),
        Target(name: "LicenseProject", dependencies: [
            .Target(name: "ProjectDescription")
        ]),
        Target(name: "PackageProject", dependencies: [
            .Target(name: "ProjectDescription")
        ])
    ],
    dependencies: [
        .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0, minor: 5)
    ]
)
