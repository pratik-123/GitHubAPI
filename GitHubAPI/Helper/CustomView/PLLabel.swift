//
//  PLLabel.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit

///normal system font size 18
class PLTitleLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    func setup() {
        font = UIFont.systemFont(ofSize: 18)
    }
}
///system font size 14
class PLSubTitleLabel: PLTitleLabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    override func setup() {
        font = UIFont.systemFont(ofSize: 14)
    }
}
