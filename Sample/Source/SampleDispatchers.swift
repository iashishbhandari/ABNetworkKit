// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleDispatcher: ABNetworkDispatcher {

    convenience init() {
        let env = ABEnvironment(host: "https://jsonplaceholder.typicode.com", type: .development)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        self.init(environment: env, configuration: .default, delegateQueue: queue)
    }
    
    required init(environment: ABEnvironment) {
        super.init(environment: environment)
        self.securityPolicy.allowInvalidCertificates = true
    }
    
    required init(environment: ABEnvironment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init(environment: environment, configuration: configuration, delegateQueue: delegateQueue)
        self.securityPolicy.allowInvalidCertificates = true
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
        self.init(environment: env, configuration: config, delegateQueue: queue)
    }
    
    required init(environment: ABEnvironment) {
        super.init(environment: environment)
        self.securityPolicy.allowInvalidCertificates = true
    }
    
    required init(environment: ABEnvironment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init(environment: environment, configuration: configuration, delegateQueue: delegateQueue)
        self.securityPolicy.allowInvalidCertificates = true
    }
}
