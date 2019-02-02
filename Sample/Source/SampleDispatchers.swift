// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleDispatcher: ABDispatcherProtocol {
    
    var dispatcher: ABDispatcherProtocol!
    
    convenience init() {
        let env = ABEnvironment(host: "https://jsonplaceholder.typicode.com", type: .development)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices.init(configuration: .default, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: env, networkServices: services, logger: ABLogger())
    }
    
    required init(environment: ABEnvironment, networkServices: ABNetworkServicesProtocol?, logger: ABLoggerProtocol?) {
        self.dispatcher = ABNetworkDispatcher(environment: environment, networkServices: networkServices, logger: logger)
    }
    
    func execute(request: ABRequestProtocol, completion: @escaping (ABNetworkResponse) -> Void) throws -> URLSessionTask? {
        do {
            return try self.dispatcher.execute(request: request, completion: completion)
        } catch {
            return nil
        }
    }
}

class BackgroundDispatcher: SampleDispatcher {
    
    convenience init() {
        let env = ABEnvironment(host: "https://dummyimage.com", type: .production)
        let config = URLSessionConfiguration.background(withIdentifier: "id.download.image")
        config.isDiscretionary = true
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices(configuration: config, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: env, networkServices: services, logger: ABLogger())
    }
    
    required init(environment: ABEnvironment, networkServices: ABNetworkServicesProtocol?, logger: ABLoggerProtocol?) {
        super.init(environment: environment, networkServices: networkServices, logger: logger)
    }
}
