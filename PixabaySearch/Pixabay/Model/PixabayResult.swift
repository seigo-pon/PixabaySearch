//
//  PixabayResult.swift
//  FaceImageCrop
//
//  Created by ueda seigo on 2018/01/19.
//  Copyright © 2018年 snowrobin. All rights reserved.
//

import Foundation
import ObjectMapper

class PixabayResult: Mappable {
    
    @objc dynamic var total = 0
    @objc dynamic var totalHits = 0
    var hits = [PixabayImage]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        total <- map["total"]
        totalHits <- map["totalHits"]
        hits <- map["hits"]
    }
    
}
