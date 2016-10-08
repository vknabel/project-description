import ProjectDescription

public enum PodspecFormat {
    case json
    case ruby

    public var podspecName: TemplateName {
        switch self {
        case .json:
            return .jsonPodspec
        case .ruby:
            return .rubyPodspec
        }
    }
}

public extension CocoapodsAction {
    /**
     * - Parameter sourceFiles: The source patterns required for Podspecs. Defaults to "Sources/{{ name }}/\*.swift".
     */
    public static func podspec(
        license: InlineTemplate = "LICENSE",
        format: PodspecFormat = .ruby,
        sourceFiles: InlineTemplate...) -> Action {
        var sources = sourceFiles
        if sourceFiles.count == 0 {
            sources.append("Sources/{{ name }}/*.swift")
        }

        var target = "{{ name }}.podspec"
        if case format = PodspecFormat.json {
            target += ".json"
        }
        return Action.write(templateNamed: format.podspecName, to: InlineTemplate(stringLiteral: target))
            .with(additional: { project, context in
                return [
                    "sourceFiles": try sources.map({ try $0.render(context) }),
                    "licensePath": try license.render(context)
                ]
            })
    }

    public static func trunkPush(ignoreWarnings: Bool = false) -> CocoapodsAction {
        let action: Action = ignoreWarnings
            ? .shell("pod", "trunk", "push", "{{ name }}.podspec", "--allow-warnings")
            : .shell("pod", "trunk", "push", "{{ name }}.podspec")
        return CocoapodsAction(action)
    }
}
