// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

public class ABPromise<T> {
    
    private var listener: ((T?)->Void)?
    
    public var value: T? {
        didSet {
            self.listener?(value)
        }
    }
    
    public init(_ listener: ((T?)->Void)?) {
        self.listener = listener
        self.listener?(value)
    }
}
