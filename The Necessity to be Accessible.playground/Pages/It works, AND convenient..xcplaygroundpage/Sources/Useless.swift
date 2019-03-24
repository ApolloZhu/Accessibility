public func does_whatever_you_think_I_Will_do() -> String {
    return "This is just a demo, but you should implement it to perform the most sense making action"
}
public func slideUpTinyBit() -> String { return "+0.01" }
public func slideDownALittle() -> String { return "-0.01" }

import Foundation
public class Contacts: NSObject {
    public static let services = Contacts()
    private override init() { super.init() }
    @objc public func call() { }
    @objc public func sendMessage() { }
}
