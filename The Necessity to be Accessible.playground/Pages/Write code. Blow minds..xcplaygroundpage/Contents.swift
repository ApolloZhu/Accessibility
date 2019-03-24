//: - Callout(Scenario): Great! It's WWDC again, and you want to celebrate it
//: by writing a piece of code that'll blow people's mind with cool animations.
import PlaygroundSupport
//: - Important: Do not show live view should you have motion sickness.
PlaygroundPage.current.liveView = makeWelcomeView()
//: That looks cool, but you start to receive complains from your users,
//: reporting that they felt sick when looking at your user interface.
//: *vestibular motion sickness*, or more commonly know as car sickness,
//: is when one's brain receives different signals from eyes and ears,
//: puzzling to figure out what's really happening.
//: - Note: iOS gives users control to turn on "Reduce Motion" in mode
//: Settings ➜ General ➜ Accessibility. Now it's enabled because the
//: user knows they'll feel unconfortable.
UIAccessibility.isReduceMotionEnabled = true
//: - Experiment: You should check `isReduceMotionEnabled` and replace some of
//: your complex animations with simpler ones (cross-fade, etc). This is also
//: great when you have a tired day and can't think straight.
if UIAccessibility.isReduceMotionEnabled {
//: To avoid really blowing up someone else's mind, we'll disable our animation,
//: and replace with a static image that also looks cool.
    disableAnimation()
} else {
//: Otherwise, we can use our cool, mind-blowing animation
    enableAnimation()
}
//: - Note: Click/Tap on the live view to see the change.
//:
//: What you just saw is an example of desinging for everyone, and giving them
//: equal access to technology. What does this really mean?
//: [➜ What is Accessibility?](@next)
