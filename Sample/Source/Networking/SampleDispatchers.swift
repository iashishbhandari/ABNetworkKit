// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

enum Host: String {
    case users = "https://jsonplaceholder.typicode.com"
    case image = "https://dummyimage.com"
}

class MainDispatcher: ABDispatcherProtocol {
    
    private var dispatcher: ABDispatcherProtocol!
    
    convenience init() {
        let env = ABNetworkEnvironment(host: Host.image.rawValue, type: .production)
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
    
    func execute(request: ABRequestProtocol, completion: @escaping (ABNetworkResponse) -> Void) throws -> URLSessionTask? {
        do {
            return try self.dispatcher.execute(request: request, completion: completion)
        } catch {
            return nil
        }
    }
}

class BackgroundDispatcher: MainDispatcher {
    
    convenience init() {
        let env = ABNetworkEnvironment(host: Host.image.rawValue, type: .production)
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
