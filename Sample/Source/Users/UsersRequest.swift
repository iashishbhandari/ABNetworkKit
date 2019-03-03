//
//  UsersRequest.swift
//  Sample
//
//  Created by ashish on 05/02/19.
//  Copyright © 2019 iashishbhandari. All rights reserved.
//

import ABNetworkKit

enum UsersRequest: ABRequestProtocol {
    
    case getUsers
    
    var actionType: ABRequestAction {
        return .data
    }
    
    var headers: [String : String]? {
        return ["content-type" : "application/json"]
    }
    
    var method: ABHTTPMethod {
        return .get
    }
    
    var parameters: ABRequestParams {
        return .url([:])
    }
    
    var path: String {
        return "/users"
    }
    
    var responseType: ABResponseType {
        return .json
    }
    
}
