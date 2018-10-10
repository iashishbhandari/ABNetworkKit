// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let backgroundDispatcher = BackgroundDispatcher()
    
    private let dispatcher = NetworkDispatcher(environment: Environment(host: "https://jsonplaceholder.typicode.com", type: .development))

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatcher.securityPolicy.allowInvalidCertificates = true
    }
    
    @IBAction func onTapFetchBtn(_ sender: Any) {
        fetchSampleUsers()
    }
    
    private func downloadSampleImage() {
        SampleOperation(SampleRequest.downloadSampleImage).execute(in: backgroundDispatcher) { [weak self] (response) in
            if let location = response.1, let data = try? Data(contentsOf: location) {
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func fetchSampleUsers() {
        SampleOperation(SampleRequest.getSampleUsers).execute(in: dispatcher) { [weak self] (response) in
            if let users = response.0, !users.isEmpty {
                for user in users {
                    print(user)
                }
                self?.showAlert(message: "Data fetched successfully!")
                
            } else if let error = response.2 {
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

