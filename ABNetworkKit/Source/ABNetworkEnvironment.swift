// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public struct ABNetworkEnvironment: ABEnvironmentProtocol {
    
    public var headers: [String: String]?
    
    public var host: String
    
    public var type: ABEnvironmentType

    private init() {
        self.host = ""
        self.type = .custom(host: host)
    }
    
    public init(host: String, type: ABEnvironmentType) {
        self.host = host
        self.type = type
    }
}



