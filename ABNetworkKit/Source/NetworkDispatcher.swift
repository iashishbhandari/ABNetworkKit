// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

open class NetworkDispatcher: NetworkServices, DispatcherProtocol {
    
    private var environment: Environment
    
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
        
        if let urlRequest = try? self.prepareURLRequest(for: request) {
            switch request.actionType {
             
            case .download:
                task = downloadTask(request: urlRequest, destination: { (url, urlResponse) -> URL in
                    return url
                }, with: { (url, urlResponse, error) in
                    completion(NetworkResponse((urlResponse as? HTTPURLResponse, nil, error), for: request))
                })
                task?.resume()
                
            case .standard:
                task = self.session?.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
                    completion(NetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request))
                })
                task?.resume()
                
            case .upload:
                task = uploadTask(for: urlRequest, from: Data())
                task?.resume()
            }
        }
        
        return task
    }
    
    private func prepareURLRequest(for request: RequestProtocol) throws -> URLRequest {

        let url_string = environment.host + request.path
        
        guard let url = URL(string: url_string) else {
            throw NetworkError.badInput
        }
        
        var url_request = URLRequest(url: url)
        
        switch request.parameters {
            
        case .body(let params):
            if let params = params as? [String: String] {
                url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } else {
                throw NetworkError.badInput
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
                throw NetworkError.badInput
            }
        }
        
        environment.headers?.forEach { url_request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { url_request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        url_request.httpMethod = request.method.rawValue
        
        return url_request
    }
}



