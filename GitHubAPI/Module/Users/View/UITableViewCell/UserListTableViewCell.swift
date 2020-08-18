//
//  UserListTableViewCell.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit
import SnapKit

class UserListTableViewCell: UITableViewCell {
    
    static let identifer = String(describing: UserListTableViewCell.self)
    lazy private var imageViewProfile = PLImageView(frame: CGRect.zero)
    lazy private var labelName = PLTitleLabel()
    lazy private var labelUserID = PLSubTitleLabel()
    lazy private var labelNodeID = PLSubTitleLabel()
    lazy private var labelScore = PLSubTitleLabel()
    lazy private var stackViewTextContainer : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        settings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settings()
    }
    
    private func settings() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(imageViewProfile)
        contentView.addSubview(stackViewTextContainer)
        stackViewTextContainer.addArrangedSubview(labelName)
        stackViewTextContainer.addArrangedSubview(labelUserID)
        stackViewTextContainer.addArrangedSubview(labelNodeID)
        stackViewTextContainer.addArrangedSubview(labelScore)
        
        imageViewProfile.snp.makeConstraints { (maker) in
            maker.size.equalTo(80)
            maker.top.equalTo(contentView.snp.top).offset(16)
            maker.left.equalTo(contentView.snp.left).offset(16)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-16).priority(750)
        }
 
        stackViewTextContainer.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(16)
            maker.left.equalTo(imageViewProfile.snp.right).offset(16)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-16).priority(750)
            maker.right.equalTo(contentView.snp.right).offset(-16).priority(750)
        }
        
        labelName.text = "Name : Lorem ipsum"
        labelUserID.text = "ID : Lorem ipsum"
        labelNodeID.text = "Node ID : Lorem ipsum"
        labelScore.text = "Score : 1"
        imageViewProfile.setImage(forURL: "https://avatars3.githubusercontent.com/u/4122993?v=4")
    }

}
