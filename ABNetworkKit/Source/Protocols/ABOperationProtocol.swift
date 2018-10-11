// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABOperationProtocol {
    
    associatedtype Output
    
    var request: ABRequestProtocol { get }
    
    func cancel() -> Void
    
    func execute(in dispatcher: ABDispatcherProtocol,_ completion:@escaping (Output)->Void) -> Void
}
