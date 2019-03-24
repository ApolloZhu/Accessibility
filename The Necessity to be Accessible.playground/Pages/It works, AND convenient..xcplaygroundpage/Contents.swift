/*:
 Probably your app is accessible now, but we want
 
 # No good design, but Excellent Design
 
 Does it take a lot of effort now? Maybe, but again,
 it'll be a lot easier to navigate your app,
 and your design will be improved as you adopt these features.

 ## Navigate It!
 
 Sometimes, what we observe as a compact interface might be hard to navigate.
 For example, for the hypothetical situation where we display my info as:
 
 ```
 Name     Age
 Zhiyu    18 in April, 2019
 ```
 
 using 4 separate UILabels, probably using some code like this:
 */
import UIKit
class MyInfoView: UIView {
    let namePromptLabel = UILabel()
    let nameDisplayLabel = UILabel()
    let agePromptLabel = UILabel()
    let ageDisplayLabel = UILabel()
    // ... implementation not shown
}
//: This looks nice, but Voice Over will read as
voiceOver(["Name",  "Age",
           "Zhiyu", "18 in April, 2019"])
//: That's not good. Instead, what we can do is to group the elements together
extension MyInfoView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
//: into one for describing name
        let nameComp = UIAccessibilityElement(accessibilityContainer: self)
        nameComp.accessibilityFrameInContainerSpace =
            namePromptLabel.frame.union(nameDisplayLabel.frame)
        nameComp.accessibilityLabel = "My name is Zhiyu"
//: and another describing the age
        let ageComp = UIAccessibilityElement(accessibilityContainer: self)
        ageComp.accessibilityFrameInContainerSpace =
            agePromptLabel.frame.union(ageDisplayLabel.frame)
        ageComp.accessibilityLabel = "My age will be 18 in April, 2019"
//: This way, voice over will have the correct navigation order,
//: and there are only 2 instead 4 elements to go through now,
//: which makes our app easier to use and faster to navigate.
        accessibilityElements = [nameComp, ageComp]
//: - Note: This technique can also be used to dissect a graph, such as the one
//: you've seen on the first page, where you could make each icon an accessible
//: element, frame it, and make it part of the view's accessible elements without
//: creating a single UIView.
    }
}
//: ## Rotors for the Pros
//: Speaking of faster navigation, we can define some custom rotors to help users
//: get to important parts of your app even faster, such as next important todo,
//: location of upcoming traffic jams on the map, etc. To do so, just
class ContactsViewController: UITableViewController {
    var contacts: [(name: String, isVIP: Bool)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//: Define a custom rotor, for example, for next VIP contact
        let vipRotor = UIAccessibilityCustomRotor(name: "VIP Contacts") {
            [tableView, contacts] (predicate) -> UIAccessibilityCustomRotorItemResult? in
//: Get the current selected contact
            let current = (predicate.currentItem.targetElement as? UITableViewCell).map {
                tableView?.indexPath(for: $0)
            } ?? tableView?.indexPathForSelectedRow
            let currentRow = current?.row ?? 0
//: Search for the index of the next VIP contact, either before or after,
//: based on the direction given by the rotor search query predicate
            let resultIndexPath: IndexPath
            switch predicate.searchDirection {
            case .next:
                guard let nextVIP = contacts[(currentRow + 1)...]
                    .firstIndex(where: { $0.isVIP })
                    else { return nil }
                resultIndexPath = IndexPath(row: nextVIP, section: 0)
            case .previous:
                guard let nextVIP = contacts[..<currentRow]
                    .lastIndex(where: { $0.isVIP })
                    else { return nil }
                resultIndexPath = IndexPath(row: nextVIP, section: 0)
            }
//: Lastly, scroll to that VIP and report the result back to Accessibility,
            tableView?.scrollToRow(at: resultIndexPath, at: .middle, animated: true)
            return tableView?.cellForRow(at: resultIndexPath).map {
                UIAccessibilityCustomRotorItemResult(targetElement: $0, targetRange: nil)
            }
        }
//: and set it as a custom rotor. As simple as that!
        accessibilityCustomRotors = [vipRotor]
    }
}
/*:
 ## Is this Magic?
 
 In addition to navigation, actions on each accessible element can also be
 improved for accessibility. The one I like the most is "magic tap,"
 */
class MagicalViewController: UIViewController {
//: If there's a core functionality that's so common that most people would think
//: of doing so, for example, answering a phone call when it comes in, you should
//: implement it using magic tap:
    override func accessibilityPerformMagicTap() -> Bool {
        does_whatever_you_think_I_Will_do()
        return true
    }
//: The next 2 methods allows you to fine-tune adjustments, for example, change
//: a slider by only a small fraction of it each time.
    override func accessibilityIncrement() { slideUpTinyBit() }
    override func accessibilityDecrement() { slideDownALittle() }
//: Sometimes, when we desing fluid interfaces, we might having something that
//: user can slide up from the bottom, such as that in Maps. But sliding up
//: might be a difficult gesture to perform for someone, so we could override
//: this method to allow them using double tap instead to open the bottom panel.
    override func accessibilityActivate() -> Bool {
        return true // meaning, we handled it.
    }
//: But also, when you aggregate several elements together, you might need to
//: provide an alternate entry in accessing the behaviors
    override func viewDidLoad() {
        super.viewDidLoad()
        accessibilityCustomActions = [
            UIAccessibilityCustomAction(name: "Call", target: Contacts.services, selector: #selector(Contacts.call)),
            UIAccessibilityCustomAction(name: "Message", target: Contacts.services, selector: #selector(Contacts.sendMessage))
        ]
    }
}
//: - Callout(Summary): I know, that's a lot of stuff. But don't worry,
//: you can always come back and visit it. But what if we can keep track
//: or your progress? Wouldn't that be great in a classroom setting? Well,
//: check out next page!
//:
//: [Previous](@previous) | [➜ Next: Making this Playground "Accessible"](@next)
