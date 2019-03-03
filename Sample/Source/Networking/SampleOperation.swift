// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleOperation: ABOperationProtocol {
    
    var sessionTask: URLSessionTask?
    
    typealias Output = ([UserEntity]?, URL?, Error?)
    
    var request: ABRequestProtocol
    
    init(_ request: ABRequestProtocol) {
        self.request = request
    }
    
    func cancel() {
       sessionTask?.cancel()
    }
    
    func execute(in dispatcher: ABDispatcherProtocol, _ completion: @escaping (([UserEntity]?, URL?, Error?)) -> Void) {
        var users: [UserEntity]?
        var error: Error?
        var fileURL: URL?
        do {
            sessionTask = try dispatcher.execute(request: request, completion: { (response) in
                
                switch response {

                case .file(let url, _):
                    fileURL = url
                    
                case .error(let err, _):
                    error = err
                    
                case .json(let JSON, _):
                    (users, error) = self.parseSampleUsers(JSON)
                }
                
                completion((users, fileURL, error))
            })
            
        } catch {
            completion((users, fileURL, error))
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
