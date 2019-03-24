> Tell us about the features and technologies you used in your Swift playground.

This playground explores scenarios and techniques to make an app accessible, and how to design with the goal of empowering every individuals to benefit from technologies equally. Thus, apparently features in *UIAccessibility* informal protocol are used to demonstrate the different tips and tricks about improving user experience through Voice Over. Due to limitations of Playgrounds, Voice Over is rather partially simulated using *AVSpeechSynthesizer*.

Since this is an iOS Playground, interfaces for demonstrating accessibility features are written with standard *UIKit* controls, constrained using *Auto Layout*, and fonts are scaled using *UIFontMetrics* in places where support for *Dynamic Type* is been discussed. But I did use Core Animation/Core Graphics/Core Image for the mind-blowing particle effect (*CAEmitterLayer*) on the first page of this playground.

As we all know, been accessible is not just about caring for those with different abilities, but also about paying to small details in meeting the demands of the diverse user groups. That’s why I used *NSLocalizedString*, formatters and date operations provided through Foundation for the purpose of internationalization and localization.

Here I define accessibility to be beyond just design, but also distribution. That is, the playground laid out road map into classrooms with *ClassKit*. At the end of the playground, there’s an evaluation phase, which is empowered by *Natural Language*, *Core ML*, and *Create ML* framework. The supplemental macOS Playground for deriving the model are included as a Resource to that playground Page. Feel free to take a look as well.

Although I’m really short on time, I made sure code quality and readability are not bad, and mostly followed good practices in using Swift (partial ranges, collection slices, etc.). And to make Playground looks aesthetically appealing, markup language, *CustomPlaygroundDisplayConvertible*, literals, and other playground essentials are used.
