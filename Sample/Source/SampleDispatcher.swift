// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleDispatcher: ABNetworkDispatcher {

    convenience init() {
        let config = URLSessionConfiguration.ephemeral
        config.isDiscretionary = true
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        self.init(environment: ABEnvironment(host: "https://jsonplaceholder.typicode.com", type: .development), configuration: config, delegateQueue: queue)
        self.securityPolicy.allowInvalidCertificates = true
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
