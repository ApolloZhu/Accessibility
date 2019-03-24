public enum Contrast {
    case notEnough(contrastRatio: CGFloat)
    case minimum(contrastRatio: CGFloat)
    case enhanced(contrastRatio: CGFloat)
}

import Foundation

extension Contrast: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        switch self {
        case .enhanced(contrastRatio: let ratio):
            return String(format: "Contrast ratio %.1f is good", ratio)
        case .minimum(contrastRatio: let ratio):
            return String(format: "Contrast ratio %.1f meets the minimum requirement", ratio)
        case .notEnough(contrastRatio: let ratio):
            return String(format: "Contrast ratio %.1f is not enough", ratio)
        }
    }
}

import UIKit

// Based on WCAG

public func isAccessibleContrast(
    between color1: UIColor, and color2: UIColor,
    forFontOfSize fontSize: CGFloat, isBold: Bool = false
) -> Contrast {
    let isLarge = isBold ? fontSize >= 14 : fontSize >= 18
    let ratio = contrastRatio(between: color1, and: color2)
    switch ratio {
    case 7...: return .enhanced(contrastRatio: ratio)
    case 4.5...: return isLarge ? .enhanced(contrastRatio: ratio) : .minimum(contrastRatio: ratio)
    case 3...: return isLarge ? .minimum(contrastRatio: ratio) : .notEnough(contrastRatio: ratio)
    default: return .notEnough(contrastRatio: ratio)
    }
}

public func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
    let L1 = color1.relativeLuminance
    let L2 = color2.relativeLuminance
    return (max(L1, L2) + 0.05) / (min(L1, L2) + 0.05)
}

extension UIColor {
    public var relativeLuminance: CGFloat {
        func transforming(_ value: CGFloat) -> CGFloat {
            if value < 0.03928 {
                return value / 12.92
            } else {
                return pow((value + 0.055) / 1.055, 2.4)
            }
        }
        let ciColor = CIColor(color: self)
        let R = transforming(ciColor.red)
        let G = transforming(ciColor.green)
        let B = transforming(ciColor.blue)
        let L = 0.2126 * R + 0.7152 * G + 0.0722 * B
        return L
    }
}
