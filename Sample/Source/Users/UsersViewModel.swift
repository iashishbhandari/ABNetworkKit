//
//  UsersViewModel.swift
//  Sample
//
//  Created by ashish on 05/02/19.
//  Copyright © 2019 iashishbhandari. All rights reserved.
//

import ABNetworkKit

class UsersViewModel {
    
    var logger: ABLoggerProtocol!
    
    init(logger: ABLoggerProtocol) {
        self.logger = logger
        self.fetchUsersData()
    }
    
    func fetchUsersData() {
        let env = ABNetworkEnvironment(host: Host.users.rawValue, type: .development)
        let dispatcher = MainDispatcher(environment: env, logger: logger)
        UsersOperation().execute(in: dispatcher) { (response) in
            if let users = response.users {
                
            } else if let error = response.error {
                
            }
        }
    }
}
