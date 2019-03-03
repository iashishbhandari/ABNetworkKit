// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

enum SampleRequest: ABRequestProtocol {
    
    case getSampleUsersData
    case downloadSampleImage(progresshandler: (Float, String)->Void)
    
    var actionType: ABRequestAction {
        switch self {
        case .downloadSampleImage(let progresshandler):
            return .download(withProgressHandler: progresshandler)
        case .getSampleUsersData:
            return .data
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
        case .getSampleUsersData:
            return .get
        }
    }
    
    var parameters: ABRequestParams {
        switch self {
        case .downloadSampleImage:
            return .url(nil)
        case .getSampleUsersData:
            return .url(nil)
        }
    }
    
    var path: String {
        switch self {
        case .downloadSampleImage:
            return "/400x600/000000/0011ff.png&text=hello!"
        case .getSampleUsersData:
            return "/users"
        }
    }
    
    var responseType: ABResponseType {
        switch self {
        case .downloadSampleImage:
            return .file(nameWithExtension: "sample.png")
        case .getSampleUsersData:
            return .json
        }
    }
}
