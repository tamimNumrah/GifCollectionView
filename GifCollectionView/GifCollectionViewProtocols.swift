//
//  GifCollectionViewProtocols.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import UIKit

protocol GifCollectionViewCustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath:IndexPath, contentWidth width: CGFloat) -> CGFloat
    func cellPaddingFor(_ collectionView: UICollectionView) -> CGFloat
}

public protocol GifCollectionViewDelegate: AnyObject {
    func didSelectGifItem(gifItem: GifItem)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

public protocol GifItem: AnyObject {
    var gifItemURL: URL { get }
    var gifItemSize: CGSize { get }
    var gifID: String { get }
}

public protocol GifProvider: AnyObject {
    func setApiKey(apiKey: String)
    func startLoadingGifs(with text: String?, completion: @escaping (_ success: Bool) -> Void)
    func loadMoreGifs(completion: @escaping (_ success: Bool, _ insertItemsAt: [IndexPath]) -> Void)
    func registerShare(gifItem: GifItem)
    func numberOfItems() -> Int
    func gifItemAt(indexPath: IndexPath) -> GifItem
}
