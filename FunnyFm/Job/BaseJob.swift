import Foundation
import Alamofire
import UIKit

open class BaseJob: Operation {
        
    open func getJobId() -> String {
        fatalError("Subclasses must implement `getJobId`.")
    }
    
    override open func main() {
        guard !isCancelled else {
            return
        }
        do {
            try run()
            return
        } catch {
            guard !isCancelled else {
                return
            }
        }
    }
    
    open func run() throws {
        
    }
        
}
