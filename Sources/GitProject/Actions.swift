import ProjectDescription

public extension GitAction {
    public static func setup() -> GitAction {
        return GitAction(.shell("git", "init"))
    }

    public static func tagAdd(
        name: InlineTemplate = "{{ version }}",
        message: InlineTemplate = "Release {{ version }}") -> GitAction {
        return GitAction(.shell("git", "tag", "-a", name, "-m", message))
    }

    public static func push(includeTags: Bool = true) -> GitAction {
        let action: Action = includeTags ? .shell("git", "push", "--tags") : .shell("git", "push")
        return GitAction(action)
    }

    public static func gitignore(ignore files: String...) -> GitAction {
        let dict: [String: [String]]
        if files.count > 0 {
            dict = ["files": files]
        } else {
            dict = [:]
        }
        let action: Action = Action.write(templateNamed: .gitignore, to: ".gitignore", additional: dict)
        return GitAction(action)
    }
}
