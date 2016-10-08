import Foundation
import Stencil
import PathKit

public extension Action {
    public static func shell(
        launchPath: InlineTemplate = "/usr/bin/env",
        _ arguments: InlineTemplate...) -> Action {
        return Action { project, context in
            let process = Process()
            process.currentDirectoryPath = Path.current.description
            process.launchPath = try launchPath.render(context)
            process.arguments = try arguments.map({ try $0.render(context) })
            process.launch()
            process.waitUntilExit()
        }
    }

    public static func combining(actions: [Action]) -> Action {
        return Action { project, context in
            try actions.forEach { action in
                _ = try action.renderer(project, context)
            }
        }
    }

    public static func write(
        templateNamed name: TemplateName,
        to pathTemplate: InlineTemplate,
        additional dictionary: [String: Any] = [:]) -> Action {
        return Action { project, context in
            let contents = try Template(search: name)
            do {
                try context.push(dictionary: dictionary) {
                    let rawPath = try pathTemplate.render(context)
                    let path = Path(rawPath)
                    try path.parent().mkpath()
                    try path.write(try contents.render(context))
                }
            } catch {
                print(error)
                throw error
            }
        }
    }

    public func with(additional dictionary: @escaping (Project, Context) throws -> [String: Any]) -> Action {
        return Action { project, context in
            let dict = try dictionary(project, context)
            return try context.push(dictionary: dict) {
                return try self.renderer(project, context)
            }
        }
    }

    public static func none() -> Action {
        return Action(rendering: { _, _ in
            return ()
        })
    }

    public static func on(_ subCommand: String) -> Action {
        return Action { _, _ in
            Project.subCommands.insert(subCommand)
        }
    }
    public static func onChange() -> Action {
        return .on("change")
    }
    public static func onInit() -> Action {
        return .on("init")
    }
}
