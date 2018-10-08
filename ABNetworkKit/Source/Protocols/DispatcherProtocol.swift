// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol DispatcherProtocol {
    
    init(environment: Environment)
    
    init(environment: Environment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue)
    
    func execute(request: RequestProtocol, completion:@escaping (NetworkResponse)->Void) throws -> URLSessionTask?
}
