// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public let ABNetworkFailingURLResponseDataErrorKey = "FailingURLResponseDataErrorKey"

public struct ABEnvironment {
    
    public var headers: [String: String]?
    
    public var host: String
    
    public var type: ABEnvironmentType
    
    init() {
        self.host = ""
        self.type = .custom(host: "")
    }
    
    public init(host: String, type: ABEnvironmentType) {
        self.host = host
        self.type = type
    }
}

public enum ABEnvironmentType {
    
    case custom(host: String)

    case development
    
    case production
}

public enum ABHTTPMethod: String {
    
    case delete = "DELETE"
    
    case get    = "GET"
    
    case patch  = "PATCH"
    
    case post   = "POST"
    
    case put    = "PUT"
}

internal enum ABNetworkError: Error {
    
    case badInput
    
    case exception
    
    case noData
}

public enum ABRequestAction {
    
    case download
    
    case standard
    
    case upload
}

public enum ABRequestParams {
    
    case body(_ : [String: Any]?)
    
    case url(_ : [String: Any]?)
}

public enum ABResponseType {
    
    case file(nameWithExtension: String)
    
    case json
}

internal enum ABSSLPinningMode {
    
    case certificate
    
    case none
}
