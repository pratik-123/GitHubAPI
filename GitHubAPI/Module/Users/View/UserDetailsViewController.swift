//
//  UserDetailsViewController.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit

class UserDetailsViewController: BaseViewController {
    
    private let bgColor : UIColor = UIColor.lightGray.withAlphaComponent(0.5)
    private let viewUserInfo = UIView()
    lazy private var imageViewProfile : PLImageView = {
        let imageView = PLImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    lazy private var stackViewInfoContainer : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy private var labelName : PLTitleLabel = {
        let labelName = PLTitleLabel()
        labelName.backgroundColor = bgColor
        return labelName
    }()
    lazy private var labelUserName : PLSubTitleLabel = {
        let label = PLSubTitleLabel()
        label.backgroundColor = bgColor
        return label
    }()
    lazy private var labelLocation : PLSubTitleLabel = {
        let label = PLSubTitleLabel()
        label.backgroundColor = bgColor
        return label
    }()
    lazy private var labelBio : PLSubTitleLabel = {
        let label = PLSubTitleLabel()
        label.backgroundColor = bgColor
        return label
    }()
    lazy private var tableViewUserFollowers : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
    }()
    var viewModel = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    /// page setup
    private func pageSetup() {
        view.backgroundColor = .white
        title = StringConstant.userDetailsTitle
        userInfoViewSettings()
        closureSetup()
        tableViewSetup()
        fetchUserData()
    }
    
    private func fetchUserData() {
        displayActivityIndicator(onView: view)
        viewModel.fetchData()
    }
}
// MARK: - Clousers
extension UserDetailsViewController {
    /// Clouser setup methods
    private func closureSetup() {
        // add error handling
        viewModel.onErrorHandling = { [weak self] error in
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
        viewModel.onRefreshHandling = { [weak self] in
            DispatchQueue.main.async {
                self?.removeActivityIndicator()
                self?.userDetailsRefresh()
                self?.tableViewUserFollowers.reloadData()
            }
        }
    }
}
// MARK: - UserInfo View methods
extension UserDetailsViewController {
    
    /// Top view user info settings
    func userInfoViewSettings() {
        view.addSubview(viewUserInfo)
        viewUserInfo.addSubview(imageViewProfile)
        viewUserInfo.addSubview(stackViewInfoContainer)
        stackViewInfoContainer.addArrangedSubview(labelName)
        stackViewInfoContainer.addArrangedSubview(labelUserName)
        stackViewInfoContainer.addArrangedSubview(labelLocation)
        stackViewInfoContainer.addArrangedSubview(labelBio)

        viewUserInfo.snp.makeConstraints { (maker) in
            maker.height.equalTo((view.bounds.size.height / 3))
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        imageViewProfile.snp.makeConstraints { (maker) in
            maker.edges.equalTo(viewUserInfo)
        }
        stackViewInfoContainer.snp.makeConstraints { (maker) in
            maker.size.height.equalTo(100).priority(750)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        userDetailsRefresh()
    }
    
    func userDetailsRefresh() {
        DispatchQueue.main.async {
            self.labelName.text =  "Name: " + (self.viewModel.objUser?.name ?? "")
        }
        labelUserName.text = "User name: "  + (viewModel.objUser?.login ?? "")
        labelLocation.text = "Location: "  + (viewModel.objUser?.location ?? "")
        labelBio.text = "Bio: " + (viewModel.objUser?.bio ?? "")
        imageViewProfile.setImage(forURL: viewModel.objUser?.avatar_url)
    }
}
// MARK: - UITableView methods
extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// tableview settings
    private func tableViewSetup() {
        view.addSubview(tableViewUserFollowers)
        tableViewUserFollowers.snp.makeConstraints { (maker) in
            maker.top.equalTo(viewUserInfo.snp.bottom).offset(0)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        tableViewUserFollowers.delegate = self
        tableViewUserFollowers.dataSource = self
        tableViewUserFollowers.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifer)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = viewModel.numberOfUser()
        return rowCount
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StringConstant.userFollowersTitle
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifer, for: indexPath) as? UserListTableViewCell
            else { return UITableViewCell() }
        cell.accessoryType = .none
        let objUser = viewModel.getUser(at: indexPath.row)
        cell.cellDataSet(from: objUser)
        return cell
    }
}
