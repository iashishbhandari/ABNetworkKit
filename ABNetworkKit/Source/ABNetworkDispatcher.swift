// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

open class ABNetworkDispatcher: ABDispatcherProtocol {
    
    private var environment: ABEnvironment!
    private var networkServices: ABNetworkServicesProtocol!
    
    public required init(environment: ABEnvironment, networkServices: ABNetworkServicesProtocol? = ABNetworkServices.defaultSharedServices) {
        self.environment = environment
        self.networkServices = networkServices
    }
    
    public func execute(request: ABRequestProtocol, completion: @escaping (ABNetworkResponse) -> Void) throws -> URLSessionTask? {
        
        var task: URLSessionTask?
        
        do {
            let urlRequest = try self.prepareURLRequest(for: request)
            switch request.actionType {
                
            case .download:
                switch request.responseType {
               
                case .file(let nameWithExtension):
                    log("Executing request ⏳ ", urlRequest)
                    task = self.networkServices.downloadTask(request: urlRequest, destination: { [weak self] (url, urlResponse) -> URL in
                        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                        var fileURL = tempDirURL
                        let filenameComponents = nameWithExtension.components(separatedBy: ".")
                        if filenameComponents.count > 1 {
                            fileURL = tempDirURL.appendingPathComponent(filenameComponents[0]).appendingPathExtension(filenameComponents[1])
                        } else {
                            fileURL = tempDirURL.appendingPathComponent("temp").appendingPathExtension("png")
                        }
                        try? FileManager.default.removeItem(at: fileURL)
                        self?.log("Destination file URL ⚠️ \(fileURL.absoluteString)")
                        return  fileURL
                        
                        }, progressHandler: { [weak self] (fractionCompleted, fileSizeInfo) in
                            self?.log("Received progress ⏳ ", "\(fractionCompleted*100)%")
                            switch request.actionType {
                            case .download(let progressHandler):
                                progressHandler?(fractionCompleted, fileSizeInfo)
                            case .standard, .upload:
                                break
                            }
                            
                        }, completionHandler: { [weak self] (fileURL, urlResponse, error) in
                            self?.log("Received response 👍 ", urlResponse)
                            if let _ = error {
                                completion(ABNetworkResponse.error(error, urlResponse as? HTTPURLResponse))
                            } else {
                                completion(ABNetworkResponse.file(location: fileURL, urlResponse as? HTTPURLResponse))
                            }
                    })
                    task?.resume()
                    
                case .json:
                    log("DownloadTask needs a file location ⚠️ ")
                    completion(ABNetworkResponse.error(ABNetworkError.badInput, nil))
                }
                
                
            case .standard:
                log("Executing request ⏳ ", urlRequest)
                task = self.networkServices.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
                    self?.log("Received response 👍 ", urlResponse)
                    DispatchQueue.main.async {
                        completion(ABNetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request))
                    }
                })
                task?.resume()
                
            case .upload:
                task = self.networkServices.uploadTask(for: urlRequest, fromFile: URL(string: "")!, completion: { [weak self] (data, urlResponse, error) in
                    self?.log("Received response 👍 ", urlResponse)
                    completion(ABNetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request))
                })
                task?.resume()
            }
            
        } catch {
            log("Got request Exception 🤭 ", error)
            completion(ABNetworkResponse.error(error, nil))
        }
        
        return task
    }
    
    private func prepareURLRequest(for request: ABRequestProtocol) throws -> URLRequest {

        switch self.environment.type! {
        case ABEnvironmentType.production:
            break
        case ABEnvironmentType.custom(let hostPath):
            environment.host = hostPath
        default:
            break
        }
        
        let url_string = environment.host + request.path
        
        guard !url_string.isEmpty, let url = URL(string: url_string) else {
            log("Bad host url ⚠️ ", url_string)
            throw ABNetworkError.badInput
        }
        
        var url_request = URLRequest(url: url)
        
        switch request.parameters {
            
        case .body(let params):
            if let params = params as? [String: String] {
                url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } else {
                log("No request body ⚠️ ", request)
            }
            
        case .url(let params):
            if let params = params as? [String: String] {
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: url_string) else {
                    throw ABNetworkError.badInput
                }
                if query_params.count > 0 {
                    components.queryItems = query_params
                    url_request.url = components.url
                }
            } else {
                log("No request params ⚠️ ", request)
            }
        }
        
        environment.headers?.forEach { url_request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { url_request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        url_request.httpMethod = request.method.rawValue
        
        return url_request
    }
}

extension ABNetworkDispatcher {
    
    public func log(_ entry: Any? ...) {
        
        switch environment.type! {
        case .development:
            print("DISPATCHER ☞ ", entry.filter { $0 != nil }.map { $0! })
        default:
            break
        }
    }
}
