// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

@objcMembers open class ABNetworkServices: NSObject {
    
    open var securityPolicy = ABNetworkSecurityPolicy.defaultPolicy
    
    open var session: URLSession?
    
    open var sessionDidReceiveAuthenticationChallenge: ((URLSession, URLAuthenticationChallenge, inout URLCredential?)->URLSession.AuthChallengeDisposition)?
    
    open var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, URLResponse, URLRequest)->URLRequest)?
    
    public static let defaultSharedServices: ABNetworkServices = {
        let concurrentQueue = OperationQueue()
        concurrentQueue.maxConcurrentOperationCount = 3
        concurrentQueue.qualityOfService = .userInitiated
        let defaultSessionConfiguration = URLSessionConfiguration.default
        defaultSessionConfiguration.timeoutIntervalForResource = 180
        if #available(iOS 11, *) {
            defaultSessionConfiguration.waitsForConnectivity = true
        }
        return ABNetworkServices(configuration: defaultSessionConfiguration, delegateQueue: concurrentQueue)
    }()
    
    public var currentRequest: URLRequest? {
        return request
    }
    
    private var request: URLRequest?
    
    private override init() {
        super.init()
    }
    
    public init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
    }
    
    open func dataTask(with request: URLRequest, completionHandler: @escaping (Any?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        
        self.request = request
        let dataTask = session?.dataTask(with: request) { (data, response, error) in
            var json: Any?
            var error = error
            if let data = data {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                } catch (let exception) {
                    error = exception
                }
            }
            DispatchQueue.main.async {
                completionHandler(json, response, error)
            }
        }
        return dataTask
    }
    
    open func downloadTask(request: URLRequest, destination: @escaping (URL, URLResponse?)->URL, with completion: @escaping (URL?, URLResponse?, Error?)->Void) -> URLSessionDownloadTask? {
        
        self.request = request
        let downloadTask = session?.downloadTask(with: request) { (fileURL, response, error) in
            var downloadFileURL: URL?
            var downloadFileError = error
            if let location = fileURL,
                let response = response {
                downloadFileURL = destination(location, response)
                if let downloadFileURL = downloadFileURL {
                    do {
                        try FileManager.default.moveItem(at: location, to: downloadFileURL)
                    } catch {
                        downloadFileError = error
                    }
                }
            }
            DispatchQueue.main.async {
                completion(downloadFileURL, response, downloadFileError)
            }
        }
        return downloadTask
    }
    
    open func uploadTask(for request: URLRequest, fromFile fileURL: URL, completion: @escaping (Data?, URLResponse?, Error?)->Void) -> URLSessionUploadTask? {
        
        self.request = request
        let uploadTask = session?.uploadTask(with: request, fromFile: fileURL, completionHandler: { (data, urlResponse, error) in
            completion(data, urlResponse, error)
        })
        return uploadTask
    }
}

extension ABNetworkServices: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        var redirectionRequest = request
        if let taskWillPerformHTTPRedirection = self.taskWillPerformHTTPRedirection {
            redirectionRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }
        completionHandler(redirectionRequest)
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var credential: URLCredential?
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        if let sessionDidReceiveAuthenticationChallenge = self.sessionDidReceiveAuthenticationChallenge {
            disposition = sessionDidReceiveAuthenticationChallenge(session, challenge, &credential)
        } else {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if securityPolicy.evaluateServerTrust(challenge.protectionSpace.serverTrust, forDomain: challenge.protectionSpace.host) {
                    if let trust = challenge.protectionSpace.serverTrust {
                        credential = URLCredential(trust: trust)
                    }
                    if let _ = credential {
                        disposition = .useCredential
                    } else {
                        disposition = .performDefaultHandling
                    }
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            } else {
                disposition = .performDefaultHandling
            }
        }
        completionHandler(disposition, credential)
    }
}
