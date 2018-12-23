//
//  CustomImageView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    private lazy var loaderService: IRequestLoader = RequestLoader()
    private var currentUrl: String?
    
    func pixabayLoader(url: String) {
        currentUrl = url
        
        image = UIImage(named: "ImagePlaceholder")
    
        loaderService.cancel()
        loaderService.load(url: url) { (data) in
            guard let data = data else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                if self?.currentUrl == url {
                    self?.image = UIImage(data: data)
                }
            }
        }
    }

}
