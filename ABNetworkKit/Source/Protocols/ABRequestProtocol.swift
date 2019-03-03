// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABRequestProtocol {
    
    var actionType: ABRequestAction       { get }
    
    var headers: [String : String]?       { get }
    
    var method: ABHTTPMethod              { get }
    
    var parameters: ABRequestParams       { get }
    
    var path: String                      { get }
    
    var responseType: ABResponseType      { get }
}

public enum ABRequestAction {
    
    case data
    case download(withProgressHandler: ((Float, String)->Void)?)
    case upload
}

public enum ABHTTPMethod: String {
    
    case delete = "DELETE"
    case get    = "GET"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
}

public enum ABRequestParams {
    
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public enum ABResponseType {
    
    case file(nameWithExtension: String)
    case json
}
