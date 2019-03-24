import ClassKit

public protocol Node {
    var parent: Node? { get }
    var children: [Node]? { get }
    var identifier: String { get }
    var title: String { get }
    var contextType: CLSContextType { get }
}

extension Node {
    public var identifierPath: [String] {
        var pathComponents = [identifier]
        if let parent = parent {
            pathComponents = parent.identifierPath + pathComponents
        }
        return pathComponents
    }
    
    /// Finds a node in the play list hierarchy by its identifier path.
    public func descendant(matching identifierPath: [String]) -> Node? {
        guard let identifier = identifierPath.first else { return self }
        return children?.first(where: { $0.identifier == identifier })?
            .descendant(matching: Array(identifierPath[1...]))
    }
}

public struct Playground {
    public struct Page {
        public struct Section {
            public let title: String
            fileprivate(set) var id: Int!
            fileprivate(set) var page: Page!
            init(title: String) {
                self.title = title
            }
        }
        let id: Int
        public let title: String
        public private(set) var sections: [Section]?
        private static var nextId = 0
        init(title: String, sections: [Section]?) {
            self.id = Page.nextId
            Page.nextId += 1
            self.title = title
            self.sections = sections
            let newSections = self.sections?.enumerated().map {
                (id, oldSection) -> Section in
                var section = oldSection
                section.id = id
                section.page = self
                return section
            }
            self.sections = newSections
        }
    }
    public let pages: [Page]
}

extension Playground.Page: Node {
    public var parent: Node? { return nil }
    public var children: [Node]? { return sections }
    public var identifier: String { return "page-\(id)" }
    public var contextType: CLSContextType { return .chapter }
}

extension Playground.Page.Section: Node {
    public var parent: Node? { return page }
    public var children: [Node]? { return nil }
    public var identifier: String { return "section-\(id!)" }
    public var contextType: CLSContextType { return .section }
}

let structure: [(page: String, sections: [String])] = [
    (NSLocalizedString("Write code. Blow minds.", comment: ""), []),
    (NSLocalizedString("Intro to Accessibility", comment: ""), [
        NSLocalizedString("What is \"Accessibility\"?", comment: ""),
        NSLocalizedString("Basics of been Accessible", comment: "")
        ]),
    (NSLocalizedString("Colors", comment: ""), [
        NSLocalizedString("More than just Colors", comment: ""),
        NSLocalizedString("Semantics, with or without Color", comment: "")
        ]),
    (NSLocalizedString("Universal Design", comment: ""), [
        NSLocalizedString("Designed for EVERYONE", comment: ""),
        NSLocalizedString("Localization", comment: ""),
        NSLocalizedString("RTL and Text Display", comment: ""),
        NSLocalizedString("Numbers and Formatters", comment: ""),
        NSLocalizedString("Date and Calendars", comment: "")
        ]),
    (NSLocalizedString("It works, AND convenient.", comment: ""), [
        NSLocalizedString("No good design, but Excellent Design", comment: ""),
        NSLocalizedString("Aggregate", comment: ""),
        NSLocalizedString("Disect", comment: ""),
        NSLocalizedString("Fine Tune", comment: "")
        ]),
    (NSLocalizedString("Share this playground", comment: ""), [
        NSLocalizedString("Expose Contents", comment: ""),
        NSLocalizedString("Record Learning Activity", comment: ""),
        ]),
    (NSLocalizedString("What's Next?", comment: ""), [
        NSLocalizedString("Where to go from here?", comment: ""),
        NSLocalizedString("Feedback", comment: "")
        ]),
]

extension Playground {
    public static let current = Playground(pages: structure.map {
        return Playground.Page(title: $0.page, sections: $0.sections.map {
            return Playground.Page.Section(title: $0)
        })
    })
}

extension Node {
    /// We could have used `activeContext` and `runningActivity`, but
    /// in cases where there are more than one context and activity,
    /// that'll not do what we intended. Therefore implemention is lookup.
    public func withContext(do process: @escaping (CLSContext) -> Void) {
        CLSDataStore.shared.mainAppContext.descendant(matchingIdentifierPath: identifierPath)
        { (context, error) in
            guard let context = context else {
                return print(error?.localizedDescription ?? "Unknown CLSError")
            }
            process(context)
            CLSDataStore.shared.save { (error) in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
        }
    }
}

extension Playground: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return pages.reduce("") {
            (result: String, page: Playground.Page) -> String in
            let sections: String = page.sections?.reduce("", {
                return "\($0)\t+ \($1.title)\n"
            }) ?? ""
            return "\(result)- **\(page.title)**\n\(sections)\n"
        }
    }
}
