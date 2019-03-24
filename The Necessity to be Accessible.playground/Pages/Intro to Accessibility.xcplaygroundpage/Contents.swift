/*:
 # What is "Accessibility"?

 Accessibility is the design of products, devices, services, or environments for people with disabilities.
 Based on [World Health Organization](https://www.who.int/topics/disabilities/en/),
 over 1,000,000,000 (1 billion) people have some kind of disabilitiy, that is,
 **1 out of every 7** users of your app needs to interact with your app through *Voice Over*.
 And you might need to use it too (hint hint, temporary disability, or simply when you are old).

 But been accessible is not just rewriting your app for those with disabilities,
 it's improving the user experience for everyone, because Voice Over is not just a screen reader,
 but an alternative method to navigate and test your awesome apps,
 and a great way to show your app is truly easy to use and easy to understand.

 - Example: My dad always says he get everything correct on exams with his eyes closed.
 Can you navigate and use your app without seeing it with your eyes? Probably not.

 You may concern about not having enough time to add support for accessibility features,
 but really, you *want* to become part of the ecosystem, because users are expecting that.
 They can already tripple tap on an image to get an automatically generated description,
 and using system-provided UIKit controls already provides a fair experience.

 You may still not be convineced, wondering why would your small user base ever use your app that way.
 - Important: However, it's exactly the other way around.
 It's **YOU** who empowers more users to enjoy your app, to be free, independent, and equal.
 And it is your ***Responsibility*** to NOT discriminate against any single individual.

 Either way, why don't we give it a try and see for yourself?
 */
//: ## Basics of been accessible
//: The most common problem is some elements of your UI a not exposed to Voice Over.
import UIKit
//: - Example: Here we are using a `UIImageView` with an icon image to serve as a button, but Voice Over users can't access it because by default, images are not accessible elements (you probably don't want a background image to be read out for it's not an essential part of your application).
let button = makeThemeChoosingImageButton()
//: But in this case, we do want to make it sounds like a button to Voice Over users.
//: - Experiment: So what do we need to do? That's simple:
//: 1. make it an accessible element
button.isAccessibilityElement = true
//: 2. Use a label to describe what it is
button.accessibilityLabel = "Switch Theme"
//: 3. Add a button trait to describe its role
button.accessibilityTraits = [.button, button.accessibilityTraits]
//: 4. If applicable, assign it a value description
button.accessibilityValue = "Light Theme"
//: 5. And provide a hint so users know what they can do with it
button.accessibilityHint = "Double tap to switch theme"
//: That's it. Isn't that simple?
//:
//: - Note: The process will be the same if you have some other custom views
//: serving as a control or been used to display information.
//:
//: [Previous](@previous) | [➜ Next: Colors](@next)
