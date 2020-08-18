//
//  PLImageView.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit
import SDWebImage

class PLImageView: UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        contentMode = .scaleAspectFit
        layer.cornerRadius = 16
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
    
    /// Set image from string URL and cache image
    /// - Parameter path: string url
    func setImage(forURL path: String?){
        if let strPath = path, let url = URL(string: strPath) {
            self.sd_setImage(with: url)
        }
    }
}
