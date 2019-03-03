//
//  UsersViewController.swift
//  Sample
//
//  Created by ashish on 04/02/19.
//  Copyright © 2019 iashishbhandari. All rights reserved.
//

import UIKit
import ABNetworkKit

class UsersViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    
    private var viewModel: UsersViewModel!
    private var logger: ABLoggerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.dataSource = self
        self.tableView.rowHeight = 200
        self.tableView.estimatedRowHeight = 200
        self.view.addSubview(tableView)
        
        self.logger = ABNetworkLogger()
        self.viewModel = UsersViewModel(logger: logger)
    }
}


extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 28
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let cel = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") {
            cell = cel
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
        }
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    
    
    
}
