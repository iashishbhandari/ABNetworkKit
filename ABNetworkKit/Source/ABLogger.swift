// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public class ABLogger: ABLoggerProtocol {
    
    public init() {}
    
    public func log(_ entry: Any? ...) {
        print("ABLOGGER ☞ ", entry.filter { $0 != nil }.map { $0! })
    }
}
