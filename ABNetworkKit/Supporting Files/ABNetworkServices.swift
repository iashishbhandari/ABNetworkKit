// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

/******************************************************************************************
 
 This class can be replaced with any Network API client conforming to 'ABServicesProtocol'
 
 *****************************************************************************************/

import Foundation

public class ABNetworkServices: NSObject {
    
    public var request: URLRequest?
    public var securityPolicy = ABNetworkSecurityPolicy.policy(withCerficates: nil)
    public var session: URLSession?
    public var sessionDidReceiveAuthenticationChallenge: ((URLSession, URLAuthenticationChallenge, inout URLCredential?)->URLSession.AuthChallengeDisposition)?
    
    private var downloadTaskFileLocationWithHandlers: ( ((URL, URLResponse?)->URL)?, ((Float, String)->Void)?, ((URL?, URLResponse?, Error?)->Void)? )
    private var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, URLResponse, URLRequest)->URLRequest)?

    public override convenience init() {
        let concurrentQueue = OperationQueue()
        concurrentQueue.maxConcurrentOperationCount = 3
        concurrentQueue.qualityOfService = .userInitiated
        let defaultSessionConfiguration = URLSessionConfiguration.default
        defaultSessionConfiguration.timeoutIntervalForResource = 180
        if #available(iOS 11, *) {
            defaultSessionConfiguration.waitsForConnectivity = true
        }
        self.init(configuration: defaultSessionConfiguration, delegateQueue: concurrentQueue)
    }
    
    public init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
    }
}

extension ABNetworkServices: ABServicesProtocol {
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Any?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        
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
    
    public func downloadTask(request: URLRequest, destination: @escaping (URL, URLResponse?)->URL, progressHandler: @escaping (Float, String)->Void, completionHandler: @escaping (URL?, URLResponse?, Error?)->Void) -> URLSessionDownloadTask? {
        
        self.request = request
        self.downloadTaskFileLocationWithHandlers = (destination, progressHandler, completionHandler)
        return session?.downloadTask(with: request)
    }
    
    public func uploadTask(for request: URLRequest, fromFile fileURL: URL, completion: @escaping (Data?, URLResponse?, Error?)->Void) -> URLSessionUploadTask? {
        
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

extension ABNetworkServices: URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var downloadFileURL: URL?
        var downloadFileError: Error?
        if let destination = downloadTaskFileLocationWithHandlers.0 {
            downloadFileURL = destination(location, downloadTask.response)
            if let downloadFileURL = downloadFileURL {
                do {
                    try FileManager.default.moveItem(at: location, to: downloadFileURL)
                } catch {
                    downloadFileError = error
                }
            }
        }
        DispatchQueue.main.async {
            self.downloadTaskFileLocationWithHandlers.2?(downloadFileURL, downloadTask.response, downloadFileError)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let handler = self.downloadTaskFileLocationWithHandlers.1 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            DispatchQueue.main.async {
                handler(progress, totalSize)
            }
        }
    }
}
