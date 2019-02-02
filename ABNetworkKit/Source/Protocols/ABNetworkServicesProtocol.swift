// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


public protocol ABNetworkServicesProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Any?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?
    
    func downloadTask(request: URLRequest, destination: @escaping (URL, URLResponse?)->URL, progressHandler: @escaping (Float, String)->Void, completionHandler: @escaping (URL?, URLResponse?, Error?)->Void) -> URLSessionDownloadTask?
    
    func uploadTask(for request: URLRequest, fromFile fileURL: URL, completion: @escaping (Data?, URLResponse?, Error?)->Void) -> URLSessionUploadTask?
}
