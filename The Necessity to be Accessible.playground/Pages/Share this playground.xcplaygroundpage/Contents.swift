/*:
 # Teaching Others about Accessibility
 
 I hope you have enjoyed this playground
 */
Playground.current
/*: ... and is eager to allow more people to
 learn about accessibility through this then go out to support people with needs.
 
 One way to do that is adopting ClassKit, so teachers can assign it to students,
 should we have modified this to fit into an app.
 */
import ClassKit
//: ## Expose Contents
public class ClassKitContentProvider: NSObject, CLSDataStoreDelegate {
//: Starting from iOS 12.2, you'll be able to create an app extension
//: with base class conforming to `CLSContextProvider` to handle the creation.
    public func makeAvailableToClassKit() {
        for page in Playground.current.pages {
            if let sections = page.sections {
                for section in sections {
                    CLSDataStore.shared.mainAppContext
                        .descendant(matchingIdentifierPath: section.identifierPath,
                                    completion: { _,_ in })
                }
            } else {
                CLSDataStore.shared.mainAppContext
                    .descendant(matchingIdentifierPath: page.identifierPath,
                                completion: { _,_ in })
            }
        }
    }
//: Listen for context creation
    public static let shared = ClassKitContentProvider()
    private override init() {
        super.init()
        CLSDataStore.shared.delegate = self
    }
    public func createContext(forIdentifier identifier: String,
                              parentContext: CLSContext,
                              parentIdentifierPath: [String]) -> CLSContext? {
//: Find a node in the playground structure based on the identifier path.
        let identifierPath = parentIdentifierPath + [identifier]
//: Find the node to create create context with in playground.
        guard let pageIdentifier = identifierPath.first,
            let page = Playground.current.pages.first(where: { $0.identifier == pageIdentifier }),
            let node = page.descendant(matching: Array(identifierPath[1...]))
            else { return nil }
//: Create our context with information found.
        let context = CLSContext(type: node.contextType,
                                 identifier: identifier,
                                 title: node.title)
        context.topic = .computerScienceAndEngineering
//: Use universal link to locate the content.
//: - Note: You can also use user activity
        identifierPath.joined(separator: "/")
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            .map { context.universalLinkURL = URL(string: "ntba://" + $0) }
//: Save our context!
        return context
    }
}
//: ---
//:
//: ## Record Learning Activity
import UIKit
//: We'll want to report the progress back to teachers, thereby creating
class PlaygroundPage: UIViewController, UIScrollViewDelegate {
    var page: Playground.Page!
//: Whenever user starts reading a playground page
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        page.withContext { context in
//: We inform the teacher that student has started reading this chapter
            context.becomeActive()
//: ... and start recording their progress.
            (context.currentActivity ?? context.createNewActivity()).start()
        }
    }
//: We'll update the progress as they play around with this accessibility tutorial
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let midY = scrollView.contentOffset.y + scrollView.frame.size.height
        let progress = midY / scrollView.contentSize.height
        page.withContext { context in
            context.currentActivity?.progress = min(max(Double(progress), 0), 1)
        }
    }
//: And when they stop reading,
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        page.withContext {
//: we inform the teacher how many lines of code were edited
            let numberOfLinesChanged = CLSQuantityItem(
                identifier: "lines-edited",
                title: NSLocalizedString("Lines Edited", comment: "Activity report title")
            )
            numberOfLinesChanged.quantity = 5
            $0.currentActivity?.primaryActivityItem = numberOfLinesChanged
//: ... and stop recording this student activity.
            $0.currentActivity?.stop()
            $0.resignActive()
        }
    }
}
//: [Previous](@previous) | [➜ Next: Next Steps](@next)
