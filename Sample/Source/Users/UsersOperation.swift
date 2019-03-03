//
//  GetUsersOperation.swift
//  Sample
//
//  Created by ashish on 05/02/19.
//  Copyright © 2019 iashishbhandari. All rights reserved.
//

import ABNetworkKit

class UsersOperation: ABOperationProtocol {
    
    var sessionTask: URLSessionTask?
    
    typealias Output = (users: [UserEntity]?, error: Error?)

    var request: ABRequestProtocol {
        return UsersRequest.getUsers
    }
    
    func cancel() {
        sessionTask?.cancel()
    }
    
    func execute(in dispatcher: ABDispatcherProtocol, _ completion: @escaping ((users: [UserEntity]?, error: Error?)) -> Void) {
        do {
            self.sessionTask = try dispatcher.execute(request: request) { (networkResponse) in
                
                switch networkResponse {
                case .error(_, _):
                    break
                case .file(_, _):
                    break
                case .json(_, _):
                    break
                }
                
            }
        } catch {
            print(error)
        }
        
    }
}
