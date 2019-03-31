// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABOperationProtocol {
    
    associatedtype Output
    
    var sessionTask: URLSessionTask? {get set}
    
    var request: ABRequestProtocol  { get }
    
    func execute(in dispatcher: ABDispatcherProtocol, result: ABPromise<Output>)
}

extension ABOperationProtocol {
    
    func cancel() {
        sessionTask?.cancel()
    }
}
