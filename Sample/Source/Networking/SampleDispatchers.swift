// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

struct Host {
    static let users = "https://jsonplaceholder.typicode.com"
    static let image = "https://dummyimage.com"
}

class MainDispatcher: ABDispatcherProtocol {
    
    private var dispatcher: ABDispatcherProtocol!
    
    convenience init() {
        let env = ABNetworkEnvironment(host: Host.users, type: .production)
        self.init(environment: env)
    }
    
    convenience init(environment: ABNetworkEnvironment, logger: ABLoggerProtocol? = ABNetworkLogger()) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices(configuration: .default, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: environment, networkServices: services, logger: logger)
    }
    
    required init(environment: ABEnvironmentProtocol, networkServices: ABServicesProtocol?, logger: ABLoggerProtocol?) {
        self.dispatcher = ABNetworkDispatcher(environment: environment, networkServices: networkServices, logger: logger)
    }
    
    func execute(request: ABRequestProtocol, result: ABPromise<ABNetworkResponse>) throws -> URLSessionTask? {
        return try dispatcher.execute(request: request, result: result)
    }
}

class BackgroundDispatcher: MainDispatcher {
    
    convenience init() {
        let env = ABNetworkEnvironment(host: Host.image, type: .production)
        let config = URLSessionConfiguration.background(withIdentifier: "id.download.image")
        config.isDiscretionary = true
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices(configuration: config, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: env, networkServices: services, logger: ABNetworkLogger())
    }
    
    required init(environment: ABEnvironmentProtocol, networkServices: ABServicesProtocol?, logger: ABLoggerProtocol?) {
        super.init(environment: environment, networkServices: networkServices, logger: logger)
    }
}
