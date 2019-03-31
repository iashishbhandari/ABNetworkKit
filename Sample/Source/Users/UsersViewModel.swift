// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class UsersViewModel {
    
    var logger: ABLoggerProtocol!
    var usersPromise: ABPromise<[UserEntity]>?
    var errorPromise: ABPromise<Error>?
    
    init(logger: ABLoggerProtocol) {
        self.logger = logger
    }
    
    func fetchUsersData() {
        let env = ABNetworkEnvironment(host: Host.users, type: .development)
        let dispatcher = MainDispatcher(environment: env, logger: logger)
        
        UsersOperation().execute(in: dispatcher, result: ABPromise<(users: [UserEntity]?, error: Error?)>({ [weak self] (result) in
            
            if let users = result?.users {
                self?.usersPromise?.value = users

            } else if let error = result?.error {
                self?.errorPromise?.value = error
            }
        }))
    }
}
