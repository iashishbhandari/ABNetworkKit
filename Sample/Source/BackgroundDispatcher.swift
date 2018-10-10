//
//  BackgroundDispatcher.swift
//  Sample
//
//  Created by Ashish Bhandari on 10/10/18.
//  Copyright © 2018 iashishbhandari. All rights reserved.
//

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
