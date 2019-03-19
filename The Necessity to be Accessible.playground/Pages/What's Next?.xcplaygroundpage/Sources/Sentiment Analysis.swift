import CoreML
import NaturalLanguage

public func Your_review_for_this_Playground(_ review: String) -> Feedback {
    let review = review.trimmingCharacters(in: .whitespacesAndNewlines)
    guard NLLanguageRecognizer.dominantLanguage(for: review) == .english
        else { return Feedback.notEnglish }
    return (try? NLModel(contentsOf: #fileLiteral(resourceName: "Sentiment140.mlmodelc")))?.predictedLabel(for: review)
        .flatMap(Feedback.init) ?? .neutral
}

public enum Feedback: String {
    case positive
    case neutral
    case negative
    case notEnglish
}

extension Feedback: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        switch self {
        case .negative:
            return "Thank you for your feedback!"
        case .neutral:
            return "I'll for sure make this playground even better!"
        case .notEnglish:
            return "Your review appears to be not mainly in English, but thank you!"
        case .positive:
            return "I'm happy that you enjoyed this playground!"
        }
    }
}
