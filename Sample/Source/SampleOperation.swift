// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleOperation: OperationProtocol {
    
    var sessionTask: URLSessionTask?
    
    typealias Output = ([SampleUser]?, URL?, Error?)
    
    var request: RequestProtocol
    
    init(_ request: RequestProtocol) {
        self.request = request
    }
    
    func cancel() {
       sessionTask?.cancel()
    }
    
    func execute(in dispatcher: DispatcherProtocol, _ completion: @escaping (([SampleUser]?, URL?, Error?)) -> Void) {
        var users: [SampleUser]?
        var error: Error?
        var location: URL?
        do {
            sessionTask = try dispatcher.execute(request: request, completion: { (response) in
                
                switch response {

                case .binary(_, _, let fileURL):
                    location = fileURL
                    
                case .error(let err, _):
                    error = err
                    
                case .json(let JSON, _):
                    (users, error) = self.parseSampleUsers(JSON)
                }
                
                completion((users, location, error))
            })
            
        } catch {
            completion((users, location, error))
        }
    }
    
    private func parseSampleUsers(_ JSON: Any?) -> ([SampleUser]?, Error?) {
        var users: [SampleUser]?
        var error: Error?
        if let jsonArray = JSON as? [[String : Any]] {
            users = [SampleUser]()
            for json in jsonArray {
                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    users?.append(try JSONDecoder().decode(SampleUser.self, from: data))
                } catch (let err) {
                    error = err
                }
            }
        }
        return (users, error)
    }
}
