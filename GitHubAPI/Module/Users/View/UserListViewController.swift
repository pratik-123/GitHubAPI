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
    private let viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    /// page setup
    private func pageSetup() {
        view.backgroundColor = .white
        title = StringConstant.userListTitle
        closureSetup()
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
// MARK: - Clousers
extension UserListViewController {
    /// Clouser setup methods
    private func closureSetup() {
        // add error handling
        self.viewModel.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                self?.removeActivityIndicator()
                switch error {
                case .custom(let message):
                    self?.showAlert(message: message)
                    break
                default:
                    self?.showAlert(message: error?.localizedDescription)
                    break
                }
            }
        }
        //refresh screen
        self.viewModel.onRefreshHandling = { [weak self] in
            DispatchQueue.main.async {
                self?.removeActivityIndicator()
                self?.tableViewUser.reloadData()
            }
        }
    }
}
// MARK: - UISearchController methods
extension UserListViewController: UISearchBarDelegate {
    
    /// search controll settings
    private func searchControllerSettings() {
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableViewUser.tableHeaderView = searchController.searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            displayActivityIndicator(onView: view)
            viewModel.searchUser(text: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel click")
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
// MARK: - UITableView methods
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
        let rowCount = viewModel.numberOfUser()
        labelNoDataFound.isHidden = ((rowCount == 0) ? false : true)
        return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifer, for: indexPath) as? UserListTableViewCell
            else { return UITableViewCell() }
        let objUser = viewModel.getUser(at: indexPath.row)
        cell.cellDataSet(from: objUser)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objUser = viewModel.getUser(at: indexPath.row) {
            let detailViewController = UserDetailsViewController()
            detailViewController.viewModel.objUser = objUser
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

