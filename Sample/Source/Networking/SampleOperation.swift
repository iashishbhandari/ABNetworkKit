// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleOperation: ABOperationProtocol {
    
    typealias Output = (users: [UserEntity]?, url: URL?, error: Error?)
    
    var sessionTask: URLSessionTask?
    
    var request: ABRequestProtocol
    
    init(_ request: ABRequestProtocol) {
        self.request = request
    }

    func execute(in dispatcher: ABDispatcherProtocol, result: ABPromise<(users: [UserEntity]?, url: URL?, error: Error?)>) {
        var users: [UserEntity]?
        var error: Error?
        var fileURL: URL?
        do {
            self.sessionTask = try dispatcher.execute(request: request, result: ABPromise( { (value) in
                guard let networkResponse = value else {
                    return
                }
                switch networkResponse {
                    
                case .file(let url, _):
                    fileURL = url
                    
                case .error(let err, _):
                    error = err
                    
                case .json(let JSON, _):
                    (users, error) = self.parseSampleUsers(JSON)
                }
                result.value = (users, fileURL, error)
            }))

        } catch {
            result.value = (users, fileURL, error)
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
