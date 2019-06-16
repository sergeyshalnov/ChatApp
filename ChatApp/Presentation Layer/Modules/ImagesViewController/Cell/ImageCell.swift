//
//  ImageCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    let customImageView: ImageViewDownloader = {
        let imageView = ImageViewDownloader()
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        addSubview(customImageView)
    
        addConstraint(NSLayoutConstraint(item: customImageView, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .centerX,
                                         multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: customImageView, attribute: .centerY,
                                         relatedBy: .equal, toItem: self, attribute: .centerY,
                                         multiplier: 1, constant: 0))
    }

}
