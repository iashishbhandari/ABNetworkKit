# ABNetworkKit
A protocol oriented approach to HTTP Networking on iOS.

ABNetworkKit supports three custom data types conforming to DispatcherProtocol, OperationProtocol and RequestProtocol. It also define some NetworkTypes to encapsulate certain required informations for URL session.


## Protocols (Swift)

###  NetworkDispatcher confirms to DispatcherProtocol 

The `NetworkDispatcher` (open to subclass) is responsible for initiating requests and forwarding on all information directly from the URL session delegate.

```swift

public protocol DispatcherProtocol {

    init(environment: Environment)

    init(environment: Environment, 
            configuration: URLSessionConfiguration, 
            delegateQueue: OperationQueue)

    func execute(request: RequestProtocol, 
                    completion:@escaping (NetworkResponse)->Void) 
                    throws -> URLSessionTask?
}

```

###  NetworkOperation confirms to OperationProtocol 

The `NetworkOperation` is responsible for executing and attaching requests to a NetworkDispatcher.

```swift

public protocol OperationProtocol {

    associatedtype Output

    var request: RequestProtocol { get }

    func cancel() -> Void

    func execute(in dispatcher: DispatcherProtocol,
                    _ completion:@escaping (Output)->Void) 
                    -> Void
}

```

###  NetworkRequest confirms to RequestProtocol 

The `NetworkRequest` is an encapsulation of all attributes and actions required for making a HTTP URLRequest. This is summoned by NetworkOperation.

```swift

public protocol RequestProtocol {

    var actionType: RequestAction       { get }

    var headers: [String: String]?      { get }

    var method: HTTPMethod              { get }

    var parameters: RequestParams       { get }

    var path: String                    { get }

    var responseType: ResponseType      { get }
}

```

## NetworkTypes (Swift)

### Environment 

The `Environment` encapsulates the host server address, type (custom, development, production) and generic headers (if any) for all URLRequests on this network.

```swift

public struct Environment {

    public var headers: [String: String]?

    public var host: String

    public var type: EnvironmentType

    init() {
        self.host = ""
        self.type = .none
    }

    public init(host: String, type: EnvironmentType) {
        self.host = host
        self.type = type
    }
}

```

### EnvironmentType 

The `EnvironmentType` supports type `custom` for replacing the host address of a particular URLRequest (e.g CDN address),  type `development` for logging network calls and type `production` for LIVE server APIs.

```swift

public enum EnvironmentType {

    case custom(String)

    case development

    case production
}

```

### HTTPMethod

The `HTTPMethod` enumeration lists the HTTP Methods for RESTful APIs.

```swift

public enum HTTPMethod: String {

    case delete = "DELETE"

    case get    = "GET"

    case patch  = "PATCH"

    case post   = "POST"

    case put    = "PUT"
}

```

### RequestAction 

The `RequestAction` represents kind of URLRequest actions.

```swift

public enum RequestAction {

    case download

    case standard

    case upload
}

```

### RequestParams 

The `RequestParams` represents URLRequest parameters url for GET and body for POST requests.

```swift

public enum RequestParams {

    case body(_ : [String: Any]?)

    case url(_ : [String: Any]?)
}

```

### ResponseType 

The `ResponseType`  represents the supported HTTP Response types.

```swift

public enum ResponseType {

    case binary

    case json
}

```

### NetworkResponse 

The `NetworkResponse` handler for converting HTTP Response to corresponding `ResponseType`

```swift

enum NetworkResponse {

    case binary(_: Data?, _: HTTPURLResponse?)

    case error(_: Error?, _: HTTPURLResponse?)

    case json(_: Any?, _: HTTPURLResponse?)
}

```

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for both Swift and Objective-C. ABStackKit is available through CocoaPods. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To install it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod "ABNetworkKit"
end
```
Then, run the following command:

```bash
$ pod install
```

## Usage


![](https://github.com/iashishbhandari/ABNetworkKit/blob/master/ABNetworkKit/Deployment/flow.png)


See the [usage][] for more info.

[usage]: https://github.com/iashishbhandari/ABNetworkKit/blob/master/ABNetworkKit/Deployment/Usage.md

## Communication

If you see a way to improve the project :

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an [issue][].
- If you **have a feature request**, open an [issue][].
- If you **want to contribute**, submit a [pull request].

Recommend following [GitHub Swift Style Guide][]

Thanks! :v:

[issue]: https://github.com/iashishbhandari/ABNetworkKit/issues
[pull request]: https://github.com/iashishbhandari/ABNetworkKit/pulls
[GitHub Swift Style Guide]: https://github.com/github/swift-style-guide

### TODO

- [ ] Add Swift Package Manager support

## Author

Ashish Bhandari, ashishbhandariplus@gmail.com

## License

ABStackKit is available under the MIT license. See the [`LICENSE`](LICENSE) file for more info.
