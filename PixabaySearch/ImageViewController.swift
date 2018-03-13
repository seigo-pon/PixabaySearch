//
//  ImageViewController.swift
//  PixabaySearch
//
//  Created by ueda seigo on 2018/03/09.
//  Copyright © 2018年 seigo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var closeBarButtonItem: UIBarButtonItem!

    private let imageLoader = ImageLoader()

    var searchImage = Variable<SearchImage?>(nil)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func bind() {
        searchImage
            .asDriver()
            .drive(onNext: { self.imageView.image = $0?.mainImage })
            .disposed(by: disposeBag)

        searchImage
            .asObservable()
            .filter {
                $0 != nil
            }
            .map { $0! }
            .filter {
                $0.mainImage == nil
            }
            .map { $0.pixabayImage.webformatURL }
            .bind(onNext: {
                self.imageLoader.downloadImage(urlString: $0)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { self.imageView.image = $1 })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        closeBarButtonItem.rx.tap
            .asDriver()
            .drive(onNext: { self.performSegue(withIdentifier: "closeImageView", sender: nil) })
            .disposed(by: disposeBag)
    }

}
