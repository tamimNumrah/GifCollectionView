//
//  GifCollectionViewCell.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import UIKit
import SDWebImage

class GifCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gifImageView: SDAnimatedImageView = {
        let view = SDAnimatedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gifImageView.stopAnimating()
    }
    
    private func addViews() {
        addSubview(gifImageView)
        NSLayoutConstraint.activate([gifImageView.topAnchor.constraint(equalTo: topAnchor),
                                     gifImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     gifImageView.leftAnchor.constraint(equalTo: leftAnchor),
                                     gifImageView.rightAnchor.constraint(equalTo: rightAnchor)])
        
    }
    
    public func setGifImage(url: URL?){
        guard let url = url else { return }
        self.gifImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.gifImageView.sd_setImage(with: url) { image, error, cache, url in
            
        }
    }
}
