//
//  ImageLoader.swift
//  FaceImageCrop
//
//  Created by ueda seigo on 2018/01/19.
//  Copyright © 2018年 snowrobin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift

struct ImageLoader {
    
    func downloadImage(urlString: String) -> Single<(String, UIImage)> {
        return Single.create(subscribe: { (observer) in
            print(urlString)
            
            Alamofire.request(urlString).responseImage(completionHandler: {
                switch $0.result {
                case .success(let image):
                    observer(.success((urlString, image)))
                    
                case .failure(let error):
                    observer(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }

}
