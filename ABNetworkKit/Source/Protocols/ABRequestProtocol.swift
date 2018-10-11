// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABRequestProtocol {
    
    var actionType: ABRequestAction       { get }
    
    var headers: [String: String]?      { get }
    
    var method: ABHTTPMethod              { get }
    
    var parameters: ABRequestParams       { get }
    
    var path: String                    { get }
    
    var responseType: ABResponseType      { get }
}
