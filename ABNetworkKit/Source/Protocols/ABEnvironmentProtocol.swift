// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABEnvironmentProtocol {
    
    var headers: [String : String]?     {get set}
    
    var host: String                    {get set}
    
    var type: ABEnvironmentType         {get set}
}

public enum ABEnvironmentType {
    case custom(host: String)
    case development
    case production
}
