import Foundation
import PathKit
import Stencil

public final class Project {
    internal static var searchDirectories: [Path] = []
    public internal(set) static var subCommands: Set<String> = Set()

    public let name: String
    public let version: String
    public let swiftVersions: [SwiftVersion]
    public let authors: [Author]
    public let source: Rendered<URL>
    public let license: Rendered<License>
    public let socialMedia: Rendered<URL>
    public let summary: InlineTemplate
    public let description: InlineTemplate

    public func context() throws -> Context {
        var dictionary: [String: Any] = [
            "name": self.name,
            "version": self.version,
            "swiftVersions": self.swiftVersions
        ]

        let render = [
            ("authors", authors.context),
            ("source", source.context),
            ("license", { try self.license.renderer(Context(dictionary: $0)).context(from: $0) }),
            ("socialMedia", socialMedia.context),
            ("summary", summary.context),
            ("description", description.context)
        ]
        try render.forEach {
            dictionary[$0.0] = try $0.1(dictionary)
        }

        return Context(dictionary: dictionary)
    }

    public init(
        name: String,
        version: String,
        swiftVersions: [SwiftVersion],
        authors: [Author],
        source: Rendered<URL>,
        license: Rendered<License>,
        socialMedia: Rendered<URL>,
        summary: InlineTemplate,
        description: InlineTemplate)
    {
        self.name = name
        self.version = version
        self.swiftVersions = swiftVersions
        self.authors = authors
        self.source = source
        self.license = license
        self.socialMedia = socialMedia
        self.summary = summary
        self.description = description
    }
}

public extension Project {
    public static func addSearchDirectory(_ path: Path) -> Void {
        Project.searchDirectories.append(path)
    }
}
