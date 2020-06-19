import Foundation
import UIKit

public class JobQueue {
    
    public let queue = OperationQueue()
    
    public init(maxConcurrentOperationCount: Int) {
        queue.name = "JobQueue"
        queue.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    open func cancelAllOperations() {
        queue.cancelAllOperations()
    }
    
    open func suspend() {
        queue.isSuspended = true
    }
    
    open func resume() {
        queue.isSuspended = false
    }
    
    @discardableResult
    open func addJob(job: BaseJob) -> Bool {
        let jobId = job.getJobId()
        guard !isExistJob(jodId: jobId) else {
            return false
        }
        queue.addOperation(job)
        return true
    }
    
    @discardableResult
    open func cancelJob(jobId: String) -> Bool {
        guard let job = findJobById(jodId: jobId) else {
            return false
        }
        job.cancel()
        return true
    }
    
    open func findJobById(jodId: String) -> BaseJob? {
        return queue.operations.first { (operation) -> Bool in
            return (operation as? BaseJob)?.getJobId() == jodId
            } as? BaseJob
    }
    
    open func isExistJob(jodId: String) -> Bool {
        guard queue.operations.count > 0 else {
            return false
        }
        return queue.operations.contains(where: { (operation) -> Bool in
            (operation as? BaseJob)?.getJobId() == jodId && !operation.isCancelled
        })
    }
    
}
