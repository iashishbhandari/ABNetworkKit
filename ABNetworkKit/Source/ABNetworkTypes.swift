// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public let ABNetworkFailingURLResponseDataErrorKey = "FailingURLResponseDataErrorKey"



internal enum ABNetworkError: Error {
    
    case badInput
    case exception
    case noData
}





internal enum ABSSLPinningMode {
    
    case certificate
    case none
}
