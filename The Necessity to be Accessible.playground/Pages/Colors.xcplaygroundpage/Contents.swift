/*:
 # More than just Colors
 
 Picking the "right" color is always an important part of UI design,
 however, there's more to consider than just "looks good to me."
 One of them is color contrast.
*/
import UIKit
/*:
 - Experiment: Tweak the parameters of the following function to see
 if your color choices are accessible at different font weight and sizes.
 You should strive for enhanced constrast ratio,
 ensure it at least meets minimum, and avoid been not enough.
 */
isAccessibleContrast(between: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), and: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forFontOfSize: 11, isBold: false)
isAccessibleContrast(between: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), and: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), forFontOfSize: 14, isBold: true)
isAccessibleContrast(between: #colorLiteral(red: 0.9960784314, green: 0.4862745098, blue: 0.6549019608, alpha: 1), and: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), forFontOfSize: 18) // not bold
//: Sometimes, users want to have a higher contrast. That's achieved by
//: enabling darker colors, reduce transparency, and/or using bold text.
//: You should make correspoding changes based on user preferences.
//: - Example:
//: The following demostrates how you can check for these settings.
enum CustomControlConfiguration { // for the advanced, this prevents init
    static var textColor: UIColor {
        return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    static var font: UIFont! {
        if UIAccessibility.isBoldTextEnabled {
            return UIFont(name: "AmericanTypewriter-Bold", size: 14)
        } else {
            return UIFont(name: "AmericanTypewriter", size: 14)
        }
    }
    static var backgroundColor: UIColor {
        if UIAccessibility.isReduceTransparencyEnabled {
            return .white
        } else {
            return UIColor.white.withAlphaComponent(0.8)
        }
    }
}
//: But I believe more users are interested in Dark Mode, wether it's the
//: Dark Mode introduced in macOS Mojave, or it's the ***Smart Invert***
//: feature introduced in iOS 11. Instead checking user preferences with:
UIAccessibility.isInvertColorsEnabled
//: it's now much simpler. We know our theme switcher button changes color
//: automatically, so it should not be inverted with the system inversion.
//: therefore, we can prevent that from happening by simply setting:
makeThemeChoosingImageButton().accessibilityIgnoresInvertColors = true
//: - Note: You probably want to set `accessibilityIgnoresInvertColors` to
//: `true` for mosto images and videos, otherwise they can look quite scary
/*:
 ---
 
 But why do we use colors? Because they convey meaning, mood, and many
 more. However, when it comes to been accessible, we have to deliver
 
 ## Semantics, with or without Color

 In different regions, the same color and symbol could actually mean
 totally different things, causing inconvenience or even misunderstanding.
 
 - Example: Japanese stock market uses red-up-green-down,
 which is the opposite of US stock exchanges!
 
 But sometimes, the semantics carried in color can be completely lost,
 should the user be color blind. That is not unusual, and I personally
 like to turn on grayscale so my eyes feel more comfortable reading.
 Based on [Colour Blind Awareness](colourblindawareness.org),
 every 1 out of 12 men and 1 in 200 women in the world is color blind,
 so you do want to make sure they can use your app just like any others.
 */
let label: UILabel = { label in
    label.text = "Wrong Answer"
    label.sizeToFit()
    label.textColor = .red
    return label
}(UILabel())
//: Here, we constructed a label displaying a line of red text, which
//: pops out for someone with normal vision. But for color blinded,
//: that difference can not be noticed, and we lost our emphasis.
//: - Experiment: Here I'm adding a strike-through, but you should also
//: try other means to emphasis it, maybe by adding a border around it.
label.attributedText = NSAttributedString(
    string: label.text!,
    attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue,
                 .baselineOffset     : 0]
)
//: [Previous](@previous) | [➜ Next: Universal Design](@next)
