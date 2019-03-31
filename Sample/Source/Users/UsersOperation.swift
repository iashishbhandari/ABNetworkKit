// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class UsersOperation: ABOperationProtocol {
   
    var sessionTask: URLSessionTask?
    
    typealias Output = (users: [UserEntity]?, error: Error?)

    var request: ABRequestProtocol {
        return UsersRequest.getUsers
    }
    
    func execute(in dispatcher: ABDispatcherProtocol, result: ABPromise<(users: [UserEntity]?, error: Error?)>) {
        do {
            
           self.sessionTask = try dispatcher.execute(request: request, result: ABPromise<ABNetworkResponse>({ value in
                guard let response = value else {
                    return
                }
                switch response {
                case .error(let error, _):
                    result.value = (nil, error)
                case .file(_, _):
                    break
                case .json(let JSON, _):
                    result.value = self.parseSampleUsers(JSON);
                }
            }))
        } catch {
            print(error)
        }
    }
    
    private func parseSampleUsers(_ JSON: Any?) -> ([UserEntity]?, Error?) {
        var users: [UserEntity]?
        var error: Error?
        if let jsonArray = JSON as? [[String : Any]] {
            users = [UserEntity]()
            for json in jsonArray {
                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    users?.append(try JSONDecoder().decode(UserEntity.self, from: data))
                } catch (let err) {
                    error = err
                }
            }
        }
        return (users, error)
    }
}
