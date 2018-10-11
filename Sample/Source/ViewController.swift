// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let dispatcher = SampleDispatcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatcher.securityPolicy.allowInvalidCertificates = true
        fetchSampleUsers()
    }
    
    @IBAction func onTapFetchBtn(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.isHidden = true
        }
        dispatcher.environmentType = .custom(host: "https://dummyimage.com")
        downloadSampleImage()
    }
    
    private func downloadSampleImage() {
        SampleOperation(SampleRequest.downloadSampleImage).execute(in: dispatcher) { [weak self] (response) in
            if let location = response.1 {
                self?.imageView.image = UIImage(contentsOfFile: location.path)
                self?.imageView.contentMode = .scaleAspectFill
                self?.showAlert(message: "Image downloaded successfully!")
            } else if let error = response.2 {
                self?.showAlert(message: error.localizedDescription)
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
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

