//
//  GifCollectionViewCell.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import UIKit
import SwiftyGif

class GifCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gifImageView: UIImageView = {
        let view = UIImageView()//SDAnimatedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.blue
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //gifImageView.stopAnimatingGif()
        //SwiftyGifManager.defaultManager.deleteImageView(gifImageView)
        //gifImageView.image = nil
    }

//    let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView()
//        indicator.hidesWhenStopped = true
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
    
    private func addViews() {
        addSubview(gifImageView)
        NSLayoutConstraint.activate([gifImageView.topAnchor.constraint(equalTo: topAnchor),
                                     gifImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     gifImageView.leftAnchor.constraint(equalTo: leftAnchor),
                                     gifImageView.rightAnchor.constraint(equalTo: rightAnchor)])
        
    }
    
    public func setGifImage(url: URL?){
        guard let url = url else { return }
        let loader = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        gifImageView.setGifFromURL(url, customLoader: loader)
    }
}
