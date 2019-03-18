/*:
 # Sentiment Analysis
 - Important: For the datasets are *too large*, in order to run this playground, please
 1. download training data from [Sentiment140](http://help.sentiment140.com/for-students/)
 2. unzip it
 3. drag and drop the 2 csv files to the `Resources` folder you see on the left
 - Experiment: Ready? Let's begin!
 */
import Cocoa
import CreateML
import NaturalLanguage
import PlaygroundSupport
//: ## Importing Datasets
func dataTable(fromFile url: URL) -> MLDataTable {
//: We can create a data table from a Sentiment140 csv file
    var table = try! MLDataTable(
        contentsOf: url,
//: But we should inform Core ML the csv doesn't have a header,
//: so it will use default column names: X1, X2, ...
        options: MLDataTable.ParsingOptions(containsHeader: false)
    )
//: Column 6 contains the sentence classified, so we rename it make it more clear
    table.renameColumn(named: "X6", to: "Text")
//: Column 1 classifies the sentence, but we have to convert it first
    table.addColumn(table.map { row -> String in
        switch row["X1"]?.intValue {
        case 0?: return Sentiment.negative.rawValue
        case 2?: return Sentiment.neutral.rawValue
        case 4?: return Sentiment.positive.rawValue
        default: fatalError("Unrecognized sentiment label")
        }
    }, named: "Label")
    return table
}
//: Now we can load the data tables:
let trainingData = dataTable(fromFile: #fileLiteral(resourceName: "training.1600000.processed.noemoticon.csv"))
let testData = dataTable(fromFile: #fileLiteral(resourceName: "testdata.manual.2009.06.14.csv"))
//: ## Creating Maching Learning Model
//: Now we have a way to generate datatables,
//: we can create a text classifier from the dataset
let sentimentClassifier = try! MLTextClassifier(
    trainingData: trainingData,
    textColumn: "Text",
    labelColumn: "Label"
)
//: ... and evaluate it with the test dataset
let evaluationMetrics = sentimentClassifier.evaluation(on: testData)
//: ## Check Our Results
//: Let's see some statistics
let trainingAccuracy = (1 - sentimentClassifier.trainingMetrics.classificationError) * 100
let validationAccuracy = (1 - sentimentClassifier.validationMetrics.classificationError) * 100
let evaluationAccuracy = (1 - evaluationMetrics.classificationError) * 100
print("""
  Training Accuracy: \(trainingAccuracy)%
Validation Accuracy: \(validationAccuracy)%
Evaluation Accuracy: \(evaluationAccuracy)%
""")
//: - Note: 😍 is positive, 😐 is neutral, and 😡 is negative
sentimentClassifier.sentiment(of: "This looks fantastic")
sentimentClassifier.sentiment(of: "It's okay")
sentimentClassifier.sentiment(of: "I didn't learn anything at all")
//: - Experiment: Why don't we test it with your comments about this playground?



//: ## Exporting MLModel
//: Now we've verified it, let's save the model with some metadata to describe it:
let metadata = MLModelMetadata(
//: - Note: Change author to **your name**. In my case, I'm Zhiyu Zhu, so:
    author: "Zhiyu Zhu",
    shortDescription: "A model trained to classify sentiment",
//: - Important: We should pay tribute to Sentiment140 as we used their dataset:
    license: "A. Go, R. Bhayani, and L. Huang, “Twitter Sentiment Classification Using Distant Supervision,” in CS224N Project Report, 2009.",
    version: "1.0"
)
//: Save the trained model as `Sentiment140.mlmodel`
let url = playgroundSharedDataDirectory.absoluteURL
    .appendingPathComponent("Sentiment140.mlmodel")
try sentimentClassifier.write(to: url, metadata: metadata)
//: Lastly, open it so we can use it later!
NSWorkspace.shared.open(url)
//: We're all set. Have a nice day!
