// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

class SampleOperation: OperationProtocol {
    
    var sessionTask: URLSessionTask?
    
    typealias Output = NetworkResponse
    
    var request: RequestProtocol {
        return SampleRequest.getSampleData
    }
    
    func cancel() {
       sessionTask?.cancel()
    }
    
    func execute(in dispatcher: DispatcherProtocol, _ completion: @escaping (NetworkResponse) -> Void) {
        do {
            sessionTask = try dispatcher.execute(request: request, completion: { (response) in
                completion(response)
            })
        } catch (let exception) {
            completion(NetworkResponse.error(exception, nil))
        }
    }
}
