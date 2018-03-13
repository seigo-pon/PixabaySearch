//
//  SearchImage.swift
//  PixabaySearch
//
//  Created by ueda seigo on 2018/03/09.
//  Copyright © 2018年 seigo. All rights reserved.
//

import UIKit

struct SearchImage {

    var pixabayImage: PixabayImage!

    var previewImage: UIImage?
    var mainImage: UIImage?

    init(pixabayImage: PixabayImage!) {
        self.pixabayImage = pixabayImage
    }
    
}
