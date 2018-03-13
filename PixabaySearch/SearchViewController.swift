//
//  SearchViewController.swift
//  PixabaySearch
//
//  Created by ueda seigo on 2018/03/08.
//  Copyright © 2018年 seigo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!

    private let pixabayApiClient = PixabayApiClient()
    private let imageLoader = ImageLoader()
    
    private var searchImages = Variable<[SearchImage]>([])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case "presentImageView":
            if let viewController = segue.destination as? UINavigationController {
                if let childViewController = viewController.topViewController as? ImageViewController {
                    childViewController.searchImage.value = (sender as? SearchImage)
                }
            }

        default:
            break
        }
    }

    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "closeImageView":
            if let viewController = segue.source as? ImageViewController {
                if let newSearchImage = viewController.searchImage.value {
                    if let index = self.searchImages.value.index(where: {
                        $0.pixabayImage.webformatURL == newSearchImage.pixabayImage.webformatURL
                    }) {
                        self.searchImages.value[index] = newSearchImage
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func bind() {
        searchBar.rx.searchButtonClicked
            .map { self.searchBar.text }
            .subscribe(
                onNext: { text in
                    if let text = text, !text.isEmpty {
                        self.pixabayApiClient.search(text: text)
                            .subscribeOn(SerialDispatchQueueScheduler(qos: .default))
                            .asObservable()
                            .map { pixabayImages in
                                var searchImages = [SearchImage]()
                                pixabayImages.forEach { searchImages.append(SearchImage(pixabayImage: $0)) }
                                return searchImages
                            }
                            .bind(to: self.searchImages)
                            .disposed(by: self.disposeBag)
                    }
                    else {
                        self.searchImages.value.removeAll()
                    }

                    self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        searchImages
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "Cell", cellType: SearchImageCell.self)) {
                (collectionView, searchImage, cell) in
                cell.setSearchImage(searchImage)

                if searchImage.previewImage == nil {
                    self.imageLoader.downloadImage(urlString: searchImage.pixabayImage.previewURL)
                        .subscribe(onSuccess: { (url, image) in
                            if let index = self.searchImages.value.index(where: { $0.pixabayImage.previewURL == url }) {
                                self.searchImages.value[index].previewImage = image
                            }
                        })
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)


        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(SearchImage.self)
            .asDriver()
            .drive(onNext: { self.performSegue(withIdentifier: "presentImageView", sender: $0) })
            .disposed(by: disposeBag)
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/4
        return CGSize(width: width, height: width)
    }
    
}

