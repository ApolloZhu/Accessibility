/*:
 # Designed for EVERYONE
 
 I don't think accessibility is just having *inclusive* design,
 but rather about having a **universal** design.
 We have to honor the diversity of our users,
 and that, in turn, will widen our user base.
 */
import UIKit
/*:
 ## Localization
 
 Yes, this is also a form of accessibility, because
 
 - Important: Not all users speak English.
 
 That's why movies usually have multiple audio tracks in different languages,
 as well as closed captions for those needing more than just audio
 (I really appreciate that when watching plays by Shakespeare).
 So we should translate our apps (and Playgrounds) as well, like this:
 */
let imageButton = makeThemeChoosingImageButton()
let localizedText_switchTheme = NSLocalizedString(
    "Switch Theme",
//: - Callout(Good Practices): many people left out the comment,
//: which is bad. You really want to provide context for translator,
//: so they can provide the best translation possible.
    comment: "Accessibility label for theme choosing button"
)
imageButton.accessibilityLabel = localizedText_switchTheme
imageButton.accessibilityValue = NSLocalizedString(
    "Light Theme",
    comment: "Name of the default, brighter theme"
)
//: and etc, etc. Remember to use `NSLocalizedString` for *everything*
//: that's displayed or spoken out in the user interface!
//:
//: ---
//:
//: ## RTL and Text Display
let view = UIView(); let label = UILabel();
view.addSubview(imageButton); view.addSubview(label)
label.text = localizedText_switchTheme
/*:
 You might be suprised that some languages are written from right to left,
 and some languages are way longer/shorter than English when written out.
 So let's fix the following constraints:
 */
label.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
//: - Experiment: Replace "left" with "leading" and "right" with "trailing"
//: so the interface will be automatically fliped when text direction should
//: be from right to left.
    imageButton.leftAnchor.constraint(equalTo: view.leftAnchor),
    imageButton.rightAnchor.constraint(equalTo: label.leftAnchor),
    label.rightAnchor.constraint(equalTo: view.rightAnchor)
])
/*:
 ---
 
 ## Numbers and Formatters
 
 You might think every one write numbers like this: 1,000.5 hours. But NO.
 In some areas, it's 1.000,5. And some places, plural is not just adding a "s".
 Instead, we should use stringsdict. It looks pretty much the same:
 */
NSLocalizedString("%.1f hour(s)", comment: "Time spent programming in hours")
//: but you should add a `stringsdict` file to your project and populate
//: translations there. Another thing you can use are formatters, such as:
let formatter: DateFormatter = { formatter in
    formatter.dateStyle = .full
    formatter.timeStyle = .none
    return formatter
}(DateFormatter())
formatter.string(from: Date())
/*:
 There are many other formatters available, such as `NumberFormatter` and
 `PersonNameComponentsFormatter`, but speaking of date, let's talk about
 
 ---
 
 ## Date and Calendars
 
 You have probably seen the value "86400" quite a lot of time, that's
 1 day calcuated by 24 hours * 60 minutes per hour * 60 seconds per minute.
 But will adding that time interval to a date always give you the same hour tomorrow?

 - Note: I thought someone would have super power to have an extra hour in a day, but no!
 
 There's something called *daylight saving time*. On March 10, 2019 in Virginia at 2 AM,
 residents all get one hour less of sleep. That'll be added back on November 3rd.
 So you really want to use `Calendar` to hand the calculation for you, like this:
 */
Calendar.current.date(byAdding: .day, value: 1, to: Date())
//: Isn't this more expressive and simpler to understand, but also more correct?
//:
//: [Previous](@previous) | [➜ Next: Even Better](@next)
