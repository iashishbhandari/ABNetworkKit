// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol OperationProtocol {
    
    associatedtype Output
    
    var request: RequestProtocol { get }
    
    func cancel() -> Void
    
    func execute(in dispatcher: DispatcherProtocol,_ completion:@escaping (Output)->Void) -> Void
}
