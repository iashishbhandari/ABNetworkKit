// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit

enum SampleRequest: RequestProtocol {
    
    case getSampleUsers
    
    case downloadSampleImage
    
    case uploadSampleVideo
    
    
    var actionType: RequestAction {
        switch self {
        case .downloadSampleImage:
            return .download
        case .getSampleUsers:
            return .standard
        case .uploadSampleVideo:
            return .upload
        }
    }
    
    var headers: [String : String]? {
        return ["content-type" : "application/json"]
    }
    
    var method: HTTPMethod {
        switch self {
        case .downloadSampleImage:
            return .get
        case .getSampleUsers:
            return .get
        case .uploadSampleVideo:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .downloadSampleImage:
            return .url(nil)
        case .getSampleUsers:
            return .url(nil)
        case .uploadSampleVideo:
            return .body(["filename" : "sample.mp4"])
        }
    }
    
    var path: String {
        switch self {
        case .downloadSampleImage:
            return "/wiki/Elizabeth_Olsen#/media/File:Elizabeth_Olsen_SDCC_2014_2_(cropped).jpg"
        case .getSampleUsers:
            return "/users"
        case .uploadSampleVideo:
            return "/upload"
        }
    }
    
    var responseType: ResponseType {
        switch self {
        case .downloadSampleImage:
            return .binary
        default:
            return .json
        }
    }
}
