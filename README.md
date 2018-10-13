# ABNetworkKit
A protocol oriented approach to HTTP Networking on iOS.

ABNetworkKit is a facade of three type-safe Swift constructs: class, struct and enum that conform to `ABDispatcherProtocol`, `ABOperationProtocol` and `ABRequestProtocol` respectively. It uses Foundation's URL Loading System to interact with URLs and communicate with servers using standard Internet protocols. It defines `ABNetworkTypes` to encapsulate request information, for establishing a URL session and asynchonously handles the incoming data or errors to user defined `NetworkResponse`


## Protocols (Swift)

###  ABDispatcherProtocol 

The included `ABNetworkDispatcher` (open to subclass) is responsible for initiating requests and forwarding on information directly from the underlying URL session. It conforms to `ABDispatcherProtocol`

```swift

public protocol ABDispatcherProtocol {

    init(environment: ABEnvironment)

    init(environment: ABEnvironment, 
            configuration: URLSessionConfiguration, 
            delegateQueue: OperationQueue)

    func execute(request: ABRequestProtocol, 
                    completion:@escaping (ABNetworkResponse)->Void) 
                    throws -> URLSessionTask?
}

```

###  ABOperationProtocol 

An Operation struct needs to be created for attaching HTTP requests to the `ABNetworkDispatcher`. It will conform to `ABOperationProtocol`

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

### ABEnvironment 

The `ABEnvironment` encapsulates the host server address, type (custom, development, production) and generic headers (if any) for all the URLRequests.

```swift

public struct ABEnvironment {

    public var headers: [String: String]?

    public var host: String

    public var type: ABEnvironmentType

    init() {
        self.host = ""
        self.type = .none
    }

    public init(host: String, type: ABEnvironmentType) {
        self.host = host
        self.type = type
    }
}

```

### ABEnvironmentType 

The `ABEnvironmentType` supports type `custom` for replacing the host address of a particular URLRequest (e.g CDN address),  type `development` for logging network calls and type `production` for LIVE server APIs.

```swift

public enum ABEnvironmentType {

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

    case download(withProgressHandler: ((Float, String)->Void)?)

    case standard

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

    case file(location: URL?, _: HTTPURLResponse?)

    case error(_: Error?, _: HTTPURLResponse?)

    case json(_: Any?, _: HTTPURLResponse?)
}

```

## ABNetworkServices (Objective C, Swift)

The base class reponsible for establishing  a network URL session for all HTTP requests. It conforms to `URLSessionTaskDelegate` and adheres to `ABNetworkSecurityPolicy`

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
