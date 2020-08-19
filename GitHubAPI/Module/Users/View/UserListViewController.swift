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
    private let searchController = UISearchController(searchResultsController: nil)
    lazy private var labelNoDataFound : PLTitleLabel = {
        let label = PLTitleLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = StringConstant.emptyUserText
        return label
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
        noDataLabelSettings()
        searchControllerSettings()
    }
    
    /// no data label setup
    private func noDataLabelSettings() {
        view.addSubview(labelNoDataFound)
        labelNoDataFound.snp.makeConstraints { (maker) in
            maker.size.equalTo(200)
            maker.center.equalTo(view)
        }
    }
}
extension UserListViewController: UISearchResultsUpdating {
    
    /// search controll settings
    private func searchControllerSettings() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableViewUser.tableHeaderView = searchController.searchBar
    }
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
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
        let rowCount = 2
        labelNoDataFound.isHidden = ((rowCount == 0) ? false : true)
        return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifer, for: indexPath) as? UserListTableViewCell
            else { return UITableViewCell() }
        return cell
    }
}

