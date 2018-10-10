// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public let NetworkFailingURLResponseDataErrorKey = "FailingURLResponseDataErrorKey"

public struct Environment {
    
    public var headers: [String: String]?
    
    public var host: String
    
    public var type: EnvironmentType
    
    init() {
        self.host = ""
        self.type = .custom("")
    }
    
    public init(host: String, type: EnvironmentType) {
        self.host = host
        self.type = type
    }
}

public enum EnvironmentType {
    
    case custom(String)

    case development
    
    case production
}

public enum HTTPMethod: String {
    
    case delete = "DELETE"
    
    case get    = "GET"
    
    case patch  = "PATCH"
    
    case post   = "POST"
    
    case put    = "PUT"
}

internal enum NetworkError: Error {
    
    case badInput
    
    case exception
    
    case noData
}

public enum RequestAction {
    
    case download
    
    case standard
    
    case upload
}

public enum RequestParams {
    
    case body(_ : [String: Any]?)
    
    case url(_ : [String: Any]?)
}

public enum ResponseType {
    
    case binary
    
    case json
}

internal enum SSLPinningMode {
    
    case certificate
    
    case none
}
