// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABDispatcherProtocol {
    
    init(environment: ABEnvironmentProtocol, networkServices: ABServicesProtocol?, logger: ABLoggerProtocol?)
    
    func execute(request: ABRequestProtocol, completion:@escaping (ABNetworkResponse)->Void) throws -> URLSessionTask?
}
