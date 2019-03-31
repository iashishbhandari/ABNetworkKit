// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import UIKit
import ABNetworkKit

class UsersViewController: UIViewController {
    
    private var tableView: UITableView!
    private var viewModel: UsersViewModel!
    private var logger: ABLoggerProtocol!
    private var users = [UserEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.rowHeight = 200
        self.tableView.estimatedRowHeight = 200
        self.view.addSubview(tableView)
        
        self.logger = ABNetworkLogger()
        self.viewModel = UsersViewModel(logger: logger)
        self.viewModel.fetchUsersData()
        self.viewModel.usersPromise = ABPromise({ (users) in
            self.users = users ?? [UserEntity]()
            self.tableView.reloadData()
        })
        self.viewModel.errorPromise = ABPromise({ (error) in
            self.showAlert(message: error?.localizedDescription ?? "Something went wrong!")
        })
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let cel = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") {
            cell = cel
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
        }
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}
