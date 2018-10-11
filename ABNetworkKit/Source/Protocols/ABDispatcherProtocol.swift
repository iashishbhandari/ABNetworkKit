// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABDispatcherProtocol {
    
    init(environment: ABEnvironment)
    
    init(environment: ABEnvironment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue)
    
    func execute(request: ABRequestProtocol, completion:@escaping (ABNetworkResponse)->Void) throws -> URLSessionTask?
}
