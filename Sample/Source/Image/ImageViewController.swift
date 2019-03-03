// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import ABNetworkKit
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onTapFetchBtn(_ sender: Any) {
        if let btn = sender as? UIButton, btn.titleLabel?.text == "Download Sample Image" {
            btn.isHidden = true
            downloadSampleImage()
        } else {
            fetchSampleUsers()
        }
    }
    
    private func downloadSampleImage() {
        SampleOperation(SampleRequest.downloadSampleImage(progresshandler: { (fractionCompleted, fileSizeInfo) in
            print("Progress: ", "\(fractionCompleted*100)% of \(fileSizeInfo)")
            
        })).execute(in: BackgroundDispatcher()) { [weak self] ( response ) in
            if let location = response.1 {
                self?.imageView.image = UIImage(contentsOfFile: location.path)
                self?.imageView.contentMode = .scaleAspectFill
                print("Image downloaded successfully!")
            } else if let error = response.2 {
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func fetchSampleUsers() {
        SampleOperation(SampleRequest.getSampleUsersData).execute(in: MainDispatcher()) { [weak self] ( response ) in
            if let users = response.0, !users.isEmpty {
                for user in users {
                    print(user)
                }
                self?.button.setTitle("Download Sample Image", for: .normal)
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

