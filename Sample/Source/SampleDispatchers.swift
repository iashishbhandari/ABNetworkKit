// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleDispatcher: ABNetworkDispatcher {

    convenience init() {
        let env = ABEnvironment(host: "https://jsonplaceholder.typicode.com", type: .development)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices.init(configuration: .default, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: env, networkServices: services)
    }
    
    required init(environment: ABEnvironment, networkServices: ABNetworkServicesProtocol?) {
        super.init(environment: environment, networkServices: networkServices)
    }
}

class BackgroundDispatcher: ABNetworkDispatcher {
    
    convenience init() {
        let env = ABEnvironment(host: "https://dummyimage.com", type: .production)
        let config = URLSessionConfiguration.background(withIdentifier: "id.download.image")
        config.isDiscretionary = true
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        let services = ABNetworkServices(configuration: config, delegateQueue: queue)
        services.securityPolicy.allowInvalidCertificates = true
        self.init(environment: env, networkServices: services)
    }
    
    required init(environment: ABEnvironment, networkServices: ABNetworkServicesProtocol?) {
        super.init(environment: environment, networkServices: networkServices)
    }
}
