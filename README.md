# ABNetworkKit
A protocol oriented approach to HTTP Networking on iOS.

ABNetworkKit is a facade of three simple type-safe constructs: request, operation and dispatcher that conform to `ABRequestProtocol`, `ABOperationProtocol` and `ABDispatcherProtocol` respectively. It uses Foundation's URL Loading System to interact with URLs and communicate with servers using standard Internet protocols. It defines `ABNetworkTypes` to encapsulate request information, for establishing a URL session and handles the network response asynchronously to user defined `ABNetworkResponse`


## Protocols (Swift)

###  ABDispatcherProtocol 

A dispatcher class needs to be created for initiating network requests, included `ABNetworkDispatcher` (replace with yours) is responsible for forwarding on a request information to the underlying URL session. It conforms to `ABDispatcherProtocol`

```swift

public protocol ABDispatcherProtocol {

    init(environment: ABNetworkEnvironment, networkServices: ABNetworkServicesProtocol?, logger: ABLoggerProtocol?)

    func execute(request: ABRequestProtocol, completion:@escaping (ABNetworkResponse)->Void) throws -> URLSessionTask?
}

```

###  ABOperationProtocol 

An operation class needs to be created for attaching HTTP requests to the `ABNetworkDispatcher`. It will conform to `ABOperationProtocol`

```swift

public protocol ABOperationProtocol {

    associatedtype Output

    var request: ABRequestProtocol { get }

    func cancel() -> Void

    func execute(in dispatcher: ABDispatcherProtocol,
                    _ completion:@escaping (Output)->Void) 
                    -> Void
}

```

###  ABRequestProtocol 

A Request enumeration needs to be created for encapsulation of all attributes and actions, required to make a URLRequest for the underlying URL session. It will conform to `ABRequestProtocol`

```swift

public protocol ABRequestProtocol {

    var actionType: ABRequestAction         { get }

    var headers: [String: String]?          { get }

    var method: ABHTTPMethod                { get }

    var parameters: ABRequestParams         { get }

    var path: String                        { get }

    var responseType: ABResponseType        { get }
}

```

## NetworkTypes (Swift)

### ABNetworkEnvironment 

The `ABNetworkEnvironment` encapsulates the host server address, type (custom, development, production) and generic headers (if any) for all the URLRequests.

```swift

public struct ABNetworkEnvironment {

    public var headers: [String: String]?
    public var host: String!
    public var type: ABNetworkEnvironmentType!

    private init() {
        self.host = ""
        self.type = .custom(host: host)
    }

    public init(host: String, type: ABNetworkEnvironmentType) {
        self.host = host
        self.type = type
    }
}


```

### ABNetworkEnvironmentType 

The `ABNetworkEnvironmentType` supports type `custom` for replacing the host address of a particular URLRequest (e.g CDN address),  type `development` for logging network calls and type `production` for LIVE server APIs.

```swift

public enum ABNetworkEnvironmentType {

    case custom(String)

    case development

    case production
}

```

### ABHTTPMethod

The `ABHTTPMethod` enumeration lists the HTTP Methods for RESTful APIs.

```swift

public enum ABHTTPMethod: String {

    case delete = "DELETE"

    case get    = "GET"

    case patch  = "PATCH"

    case post   = "POST"

    case put    = "PUT"
}

```

### ABRequestAction 

The `ABRequestAction` represents supported kind of URLRequest actions.

```swift

public enum ABRequestAction {

    case data
    
    case download(withProgressHandler: ((Float, String)->Void)?)
    
    case upload
}

```

### ABRequestParams 

The `ABRequestParams` represents parameters for a GET request or body for a POST request.

```swift

public enum ABRequestParams {

    case body(_ : [String: Any]?)

    case url(_ : [String: Any]?)
}

```

### ABResponseType 

The `ABResponseType`  represents the supported HTTP Response types.

```swift

public enum ABResponseType {

    case file(nameWithExtension: String)

    case json
}

```

### ABNetworkResponse 

The `ABNetworkResponse` handler for converting HTTP Response to corresponding `ABResponseType`

```swift

enum ABNetworkResponse {

    case error(_: Error?, _: HTTPURLResponse?)

    case file(location: URL?, _: HTTPURLResponse?)

    case json(_: Any?, _: HTTPURLResponse?)
}

```

## ABNetworkServices

The class (replace with yours) reponsible for establishing  a network URL session for all HTTP requests. It conforms to `URLSessionTaskDelegate` and adheres to `ABNetworkSecurityPolicy`

See the [usage][] for more info.


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
