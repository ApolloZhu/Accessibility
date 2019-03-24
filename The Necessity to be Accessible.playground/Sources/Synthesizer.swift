import AVFoundation
let synthesizer = AVSpeechSynthesizer()

public func voiceOver(_ ui: [String]) {
    synthesizer.speak(.init(string: ui.joined()))
}

import UIKit

public func voiceOver(_ element: UIView) -> String {
    guard element.isAccessibilityElement else {
        return "No accessible element found"
    }
    let toSpeak: String = """
    \(element.accessibilityLabel  ?? "")
    \(element.accessibilityValue  ?? "")
    \((element.accessibilityTraits.contains(.button) ? "Button" : ""))
    \(element.accessibilityHint   ?? "")
    """
    synthesizer.speak(.init(string: toSpeak))
    return toSpeak
}
