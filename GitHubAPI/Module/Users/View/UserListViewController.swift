//
//  UserListViewController.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit

class UserListViewController: BaseViewController {
    
    lazy private var tableViewUser : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    /// page setup
    private func pageSetup() {
        view.backgroundColor = .white
        title = StringConstant.userListTitle
        tableViewSetup()
    }
}
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// tableview settings
    private func tableViewSetup() {
        view.addSubview(tableViewUser)
        tableViewUser.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableViewUser.delegate = self
        tableViewUser.dataSource = self
        tableViewUser.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifer)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifer, for: indexPath) as? UserListTableViewCell
            else { return UITableViewCell() }
        return cell
    }
}

