//
//  PixabayApi.swift
//  FaceImageCrop
//
//  Created by ueda seigo on 2018/01/19.
//  Copyright © 2018年 snowrobin. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift

struct PixabayApiClient {

    private let baseUrl = "https://pixabay.com/api/"

    init() {
        self.saveEnv()
    }

    private func saveEnv() {
        guard let envPath = Bundle.main.path(forResource: ".env", ofType: nil) else {
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: envPath))
            
            if let string = String(data: data, encoding: .utf8) {
                let clean = string.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: "")
                let envVariables = clean.components(separatedBy:"\n")
                
                for envVariable in envVariables {
                    let keyVal = envVariable.components(separatedBy:"=")
                    if keyVal.count == 2 {
                        setenv(keyVal[0], keyVal[1], 1)
                    }
                }
            }
        }
        catch let error {
            print(error)
        }
    }
    
    func search(text: String) -> Single<[PixabayImage]> {
        return Single<[PixabayImage]>.create(subscribe: { observer in
            var keyword = text
            
            while let range = keyword.range(of: " ") {
                keyword.replaceSubrange(range, with: "+")
            }
            
            guard let escapedText = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                observer(.success([]))
                return Disposables.create()
            }
            
            if escapedText.isEmpty {
                observer(.success([]))
                return Disposables.create()
            }
            
            guard let appId = ProcessInfo.processInfo.environment["PIXABAY_APP_ID"] else {
                print("No set 'PIXABAY_APP_ID' key of env file.")
                observer(.success([]))
                return Disposables.create()
            }
            
            var url = self.baseUrl
            url += "?key=\(appId)"
            url += "&q=\(escapedText)"
            url += "&image_type=all"
            url += "&per_page=200"
            print(url)
            
            Alamofire.request(url).responseObject(completionHandler: { (response: DataResponse<PixabayResult>) in
                switch response.result {
                case .success(let pixabaySearch):
                    observer(.success(pixabaySearch.hits))
                    
                case .failure(let error):
                    observer(.error(error))
                }
            })

            return Disposables.create()
        })
    }

}
