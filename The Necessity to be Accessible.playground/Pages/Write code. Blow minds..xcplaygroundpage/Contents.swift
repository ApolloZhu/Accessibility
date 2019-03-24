//: - Important: You may want to disable live view should you have motion sickness.
//: - Callout(Scenario): Great! It's WWDC again, and you want to celebrate it with a cool animation you design by writing code to
import PlaygroundSupport
PlaygroundPage.current.liveView = makeWelcomeView()
UIAccessibility.isReduceMotionEnabled = true
if UIAccessibility.isReduceMotionEnabled {
    disableAnimation()
} else {
    enableAnimation()
}

//: [➜ Next: Intro to Accessibility](@next)
