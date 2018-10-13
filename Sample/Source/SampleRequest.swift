// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

enum SampleRequest: ABRequestProtocol {
    
    case getSampleUsers
    
    case downloadSampleImage(progresshandler: (Float, String)->Void)
    
    
    var actionType: ABRequestAction {
        switch self {
        case .downloadSampleImage(let progresshandler):
            return .download(withProgressHandler: progresshandler)
        case .getSampleUsers:
            return .standard
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .downloadSampleImage:
            return ["content-type" : "image/png"]
        default:
            return ["content-type" : "application/json"]
        }
    }
    
    var method: ABHTTPMethod {
        switch self {
        case .downloadSampleImage:
            return .get
        case .getSampleUsers:
            return .get
        }
    }
    
    var parameters: ABRequestParams {
        switch self {
        case .downloadSampleImage:
            return .url(nil)
        case .getSampleUsers:
            return .url(nil)
        }
    }
    
    var path: String {
        switch self {
        case .downloadSampleImage:
            return "/400x600/000000/0011ff.png&text=hello!"
        case .getSampleUsers:
            return "/users"
        }
    }
    
    var responseType: ABResponseType {
        switch self {
        case .downloadSampleImage:
            return .file(nameWithExtension: "sample.png")
        case .getSampleUsers:
            return .json
        }
    }
}
