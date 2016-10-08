import ProjectDescription

public extension PackageAction {
    public static func setup() -> PackageAction {
        return PackageAction(.shell("swift", "package", "generate-xcode-project"))
    }

    public static func linuxMain() -> PackageAction {
        return PackageAction(.write(templateNamed: .linuxMain, to: "Sources/{{ name }}/LinuxMain.swift"))
    }
}
