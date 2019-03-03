// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

public class ABNetworkSecurityPolicy: NSObject {
    
    public var allowInvalidCertificates: Bool = false
    
    private lazy var certificates: Set<Data> = {
        let paths = Bundle.main.paths(forResourcesOfType: "cer", inDirectory: ".")
        var certificates = Set<Data>(minimumCapacity: paths.count)
        for path in paths {
            if let certificate = NSData(contentsOfFile: path) as Data? {
                certificates.insert(certificate)
            }
        }
        return certificates
    }()
    
    private override init() {
        super.init()
    }
    
    public static func policy(withCerficates cer: Set<Data>?) -> ABNetworkSecurityPolicy {
        let instance = ABNetworkSecurityPolicy()
        if let certs = cer {
            instance.allowInvalidCertificates = false
            instance.certificates = certs
        } else {
            instance.allowInvalidCertificates = true
        }
        return instance
    }
    
    public func evaluateServerTrust(_ serverTrust: SecTrust?, forDomain domain: String) -> Bool {
        
        guard !allowInvalidCertificates else {
            return true
        }
        if let serverTrust = serverTrust {
            var secresult = SecTrustResultType.invalid
            let status = SecTrustEvaluate(serverTrust, &secresult)
            
            if errSecSuccess == status {
                if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                    
                    let serverCertificateData = SecCertificateCopyData(serverCertificate)
                    let data = CFDataGetBytePtr(serverCertificateData);
                    let size = CFDataGetLength(serverCertificateData);
                    let serverCert = NSData(bytes: data, length: size)
                    
                    for cert in certificates {
                        if serverCert.isEqual(to: cert) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}
