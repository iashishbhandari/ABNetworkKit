// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

open class NetworkDispatcher: NetworkServices, DispatcherProtocol {
    
    private var environment: Environment {
        didSet {
            self.environmentType = environment.type
        }
    }
    
    public var environmentType: EnvironmentType = .production
    
    private override init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        self.environment = Environment()
        super.init(configuration: configuration, delegateQueue: delegateQueue)
    }
    
    required public init(environment: Environment) {
        self.environment = environment
        super.init(configuration: .default, delegateQueue: OperationQueue())
    }

    required public init(environment: Environment, configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        self.environment = environment
        super.init(configuration: configuration, delegateQueue: delegateQueue)
    }
    
    public func execute(request: RequestProtocol, completion: @escaping (NetworkResponse) -> Void) throws -> URLSessionTask? {
        
        var task: URLSessionTask?
        
        do {
            let urlRequest = try self.prepareURLRequest(for: request)
            switch request.actionType {
                
            case .download:
                log("Executing request ⏳ ", urlRequest)
                task = downloadTask(request: urlRequest, destination: { (url, urlResponse) -> URL in
                    return url
                }, with: { [weak self] (fileURL, urlResponse, error) in
                    self?.log("Received response 👍 ", urlResponse)
                    if let _ = error {
                        completion(NetworkResponse.error(error, urlResponse as? HTTPURLResponse))
                    } else {
                        completion(NetworkResponse.binary(nil, urlResponse as? HTTPURLResponse, fileURL))
                    }
                })
                task?.resume()
                
            case .standard:
                log("Executing request ⏳ ", urlRequest)
                task = self.session?.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
                    self?.log("Received response 👍 ", urlResponse)
                    completion(NetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request))
                })
                task?.resume()
                
            case .upload:
                task = uploadTask(for: urlRequest, fromFile: URL(string: "")!, completion: { [weak self] (data, urlResponse, error) in
                    self?.log("Received response 👍 ", urlResponse)
                    completion(NetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request))
                })
                task?.resume()
            }
            
        } catch {
            log("Got request Exception 🤭 ", error)
            completion(NetworkResponse.error(error, nil))
        }
        
        return task
    }
    
    public func log(_ entry: Any? ...) {
        
        switch environment.type {
            
        case .development:
            print("DISPATCHER ☞ ", entry.filter { $0 != nil }.map { $0! })
            
        default: break
        }
    }
    
    private func prepareURLRequest(for request: RequestProtocol) throws -> URLRequest {

        switch environment.type {
            
        case .custom(let hostPath):
            environment.host = hostPath
            
        default: break
        }
        
        let url_string = environment.host + request.path
        
        guard !url_string.isEmpty, let url = URL(string: url_string) else {
            log("Bad host url ⚠️ ", url_string)
            throw NetworkError.badInput
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
                    throw NetworkError.badInput
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
