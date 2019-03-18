public enum Sentiment: String {
    case positive
    case neutral
    case negative
}

extension Sentiment: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        switch self {
        case .positive: return "😍"
        case .neutral: return "😐"
        case .negative: return "😡"
        }
    }
}

import CreateML

public extension MLTextClassifier {
    func sentiment(of text: String) -> Sentiment {
        return Sentiment(rawValue: try! prediction(from: text))!
    }
    
    func sentiments(of texts: [String]) -> [Sentiment] {
        return try! predictions(from: texts).compactMap(Sentiment.init)
    }
}
