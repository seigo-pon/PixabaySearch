//
//  PixabayImage.swift
//  FaceImageCrop
//
//  Created by ueda seigo on 2018/01/19.
//  Copyright © 2018年 snowrobin. All rights reserved.
//

import Foundation
import ObjectMapper

class PixabayImage: Mappable {

    @objc dynamic var type = ""
    @objc dynamic var previewURL = ""
    @objc dynamic var webformatURL = ""
    @objc dynamic var views = 0
    @objc dynamic var downloads = 0
    @objc dynamic var favorites = 0
    @objc dynamic var user = ""
    @objc dynamic var userImageURL = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        type <- map["type"]
        previewURL <- map["previewURL"]
        webformatURL <- map["webformatURL"]
        views <- map["views"]
        downloads <- map["downloads"]
        favorites <- map["favorites"]
        user <- map["user"]
        userImageURL <- map["userImageURL"]
    }
    
}
