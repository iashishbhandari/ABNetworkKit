// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import ABNetworkKit

class BackgroundDispatcher: NetworkDispatcher {

    convenience init() {
        let config = URLSessionConfiguration.ephemeral
        config.isDiscretionary = true
        self.init(environment: Environment(host: "https://en.wikipedia.org", type: .development), configuration: config, delegateQueue: OperationQueue())
        self.securityPolicy.allowInvalidCertificates = true
    }
    
    required init(environment: Environment) {
        super.init(environment: environment)
        self.securityPolicy.allowInvalidCertificates = true
    }
    
    required init(environment: Environment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init(environment: environment, configuration: configuration, delegateQueue: delegateQueue)
        self.securityPolicy.allowInvalidCertificates = true
    }
}
