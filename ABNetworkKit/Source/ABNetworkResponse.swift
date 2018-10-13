// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

public enum ABNetworkResponse {
    
    case file(location: URL?, _: HTTPURLResponse?)

    case error(_: Error?, _: HTTPURLResponse?)

    case json(_: Any?, _: HTTPURLResponse?)
    
    init(_ response: (httpResponse: HTTPURLResponse?, data: Data?, error: Error?), for request: ABRequestProtocol) {
        guard response.httpResponse?.statusCode == 200, response.error == nil else {
            var error = response.error
            if let errorData = response.data,
                let statusCode = response.httpResponse?.statusCode {
                error = NSError(domain: "", code: statusCode, userInfo: [ABNetworkFailingURLResponseDataErrorKey : errorData])
            }
            self = .error(error, response.httpResponse)
            return
        }
        
        switch request.responseType {
        case .file(_):
            self = .file(location: .none, response.httpResponse)
        case .json:
            do {
                if let data = response.data {
                    self =  try .json(JSONSerialization.jsonObject(with: data, options: .mutableContainers), response.httpResponse)
                } else {
                    self = .json(response.data, response.httpResponse)
                }
            } catch (let exception) {
                self = .error(exception, response.httpResponse)
            }
        }
    }
}
