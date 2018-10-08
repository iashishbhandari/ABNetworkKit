// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit
import UIKit

class ViewController: UIViewController {
    
    let dispatcher = NetworkDispatcher(environment: Environment(host: "", type: .development))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operation = SampleOperation()
        operation.execute(in: dispatcher) { (response) in
            
            switch response {
                
            case .binary(_, _):
                break
                
            case .error(let error, _):
                print("\(error!)")
                
            case .json(_, let httpResponse):
                print("\(httpResponse!)")
            }
        }
        
    }
}

