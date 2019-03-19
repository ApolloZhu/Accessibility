import CoreML
import NaturalLanguage

public func Your_review_for_this_Playground(_ review: String) -> CustomPlaygroundDisplayConvertible {
    let review = review.trimmingCharacters(in: .whitespacesAndNewlines)
    guard NLLanguageRecognizer.dominantLanguage(for: review) == .english
        else { return Feedback.notEnglish }
    do {
        let compiledModelURL = try MLModel.compileModel(at: #fileLiteral(resourceName: "Sentiment140.mlmodel"))
        let model = try NLModel(contentsOf: compiledModelURL)
        return model.predictedLabel(for: review).flatMap(Feedback.init) ?? .neutral
    } catch {
        debugPrint(error)
        return Feedback.neutral
    }
}

enum Feedback: String {
    case positive
    case neutral
    case negative
    case notEnglish
}

import UIKit

extension Feedback: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        let label = UILabel()
        switch self {
        case .negative:
            label.text = "Thank you for your feedback!"
        case .neutral:
            label.text = "I'll for sure make this playground even better!"
        case .notEnglish:
            label.text = "Your review appears to be not mainly in English, but thank you!"
        case .positive:
            label.text = "I'm happy that you enjoyed this playground!"
        }
        return label
    }
}
