// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol RequestProtocol {
    
    var actionType: RequestAction       { get }
    
    var headers: [String: String]?      { get }
    
    var method: HTTPMethod              { get }
    
    var parameters: RequestParams       { get }
    
    var path: String                    { get }
    
    var responseType: ResponseType      { get }
}
