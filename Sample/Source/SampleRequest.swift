// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

enum SampleRequest: RequestProtocol {
    
    case getSampleData
    
    var actionType: RequestAction {
        return .standard
    }
    
    var headers: [String : String]? {
        return [ : ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: RequestParams {
        return .url(nil)
    }
    
    var path: String {
        return ""
    }
    
    var responseType: ResponseType {
        return .json
    }
}
