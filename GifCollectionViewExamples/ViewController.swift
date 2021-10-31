//
//  ViewController.swift
//  GifCollectionViewExamples
//
//  Created by Tamim on 29/10/21.
//

import UIKit
import GifCollectionView

class ViewController: UIViewController {
    var gifCollectionView: GifCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addGifCollectionView()
        self.view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addGifCollectionView() {
        gifCollectionView = GifCollectionView.init()
        gifCollectionView.delegate = self
        self.view.addSubview(gifCollectionView)
        gifCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            gifCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            gifCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            gifCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        gifCollectionView.setTenorApiKey(apiKey: "D1HMEZJG1XYE")
        gifCollectionView.startLoadingGifs()
    }
}

extension ViewController: GifCollectionViewDelegate {
    func didSelectGifItem(gifItem: GifItem) {
        print("didSelectGifItem \(gifItem.gifID)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

