//
//  SearchImageCell.swift
//  PixabaySearch
//
//  Created by ueda seigo on 2018/03/09.
//  Copyright © 2018年 seigo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchImageCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    private let disposeBag = DisposeBag()

    func setSearchImage(_ searchImage: SearchImage!) {
        imageView.image = searchImage.previewImage
    }
    
}
