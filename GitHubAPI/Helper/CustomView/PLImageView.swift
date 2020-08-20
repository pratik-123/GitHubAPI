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
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// Corner radius set
    /// - Parameter cornerRadius: Radius value, defaultValue  =16
    func setCornerRadius(cornerRadius: CGFloat = 16) {
        contentMode = .scaleAspectFit
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
    
    /// Set image from string URL and cache image
    /// - Parameter path: string url
    func setImage(forURL path: String?){
        if let strPath = path, let url = URL(string: strPath) {
            self.sd_setImage(with: url,placeholderImage: UIImage(named: "ic_profile_placeholder"))
        }
    }
}
