//
//  TenorGifProvider.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import Foundation

final class TenorGifProvider: GifProvider {
    private var apiKey: String?
    
    private var lastSearchString: String?
    private var isSearching: Bool = false
    
    private var searchedGifs = [TenorGifItem]()
    private var trendingGifs =  [TenorGifItem]()
    
    private var lastPositionForTrending: String?
    private var lastPositionForSearch: String?
    
    private var apiManager: TenorAPIManager!
    
    func setApiKey(apiKey: String) {
        self.apiKey = apiKey
        self.apiManager = TenorAPIManager.init(tenorApiKey: apiKey)
    }
    
    
    func startLoadingGifs(with text: String?, completion: @escaping (_ success: Bool) -> Void) {
        if self.apiKey == nil {
            fatalError("API Key isn't set. TenorGifProvider couldn't be loaded")
        }
        if let searchText = text {
            self.isSearching = true
            self.apiManager.loadGifs(searchText: searchText, position: nil) { [weak self] success, gifs, searchText, position in
                if success {
                    self?.lastPositionForSearch = position
                    self?.searchedGifs = gifs ?? [TenorGifItem]()
                    self?.lastSearchString = searchText
                }
                completion(success)
            }
        } else {
            self.isSearching = false
            if trendingGifs.isEmpty {
                self.apiManager.loadGifs(searchText: nil, position: nil) { [weak self] success, gifs, searchText, position in
                    if success {
                        self?.lastPositionForTrending = position
                        self?.trendingGifs = gifs ?? [TenorGifItem]()
                    }
                    completion(success)
                }
            } else {
                completion(true)
            }
        }
    }
    
    func loadMoreGifs(completion: @escaping (_ success: Bool, _ insertItemsAt: [IndexPath]) -> Void) {
        if self.isSearching {
            if lastPositionForSearch == nil || lastPositionForSearch == "0" {
                completion(false, [IndexPath]())
            } else {
                self.apiManager.loadGifs(searchText: lastSearchString, position: lastPositionForSearch) { [weak self] success, gifs, searchText, position in
                    guard let self = self else { return }
                    if success, let newGifs = gifs {
                        self.lastPositionForSearch = position
                        var searchedGifsCount = self.searchedGifs.count
                        var indexPaths = [IndexPath]()
                        for gif in newGifs {
                            self.searchedGifs.append(gif)
                            indexPaths.append(IndexPath.init(row: searchedGifsCount, section: 0))
                            searchedGifsCount += 1
                        }
                        completion(true, indexPaths)
                    }
                }
            }
        } else {
            if lastPositionForTrending == nil || lastPositionForTrending == "0" {
                completion(false, [IndexPath]())
            } else {
                self.apiManager.loadGifs(searchText: nil, position: lastPositionForTrending) { [weak self] success, gifs, searchText, position in
                    guard let self = self else { return }
                    if success, let newGifs = gifs {
                        self.lastPositionForTrending = position
                        var searchedGifsCount = self.searchedGifs.count
                        var indexPaths = [IndexPath]()
                        for gif in newGifs {
                            self.trendingGifs.append(gif)
                            indexPaths.append(IndexPath.init(row: searchedGifsCount, section: 0))
                            searchedGifsCount += 1
                        }
                        completion(true, indexPaths)
                    }
                }
            }
        }
    }
    
    func registerShare(gifItem: GifItem) {
        
    }
    
    func numberOfItems() -> Int {
        if isSearching {
            return self.searchedGifs.count
        }
        return self.trendingGifs.count
    }
    
    func gifItemAt(indexPath: IndexPath) -> GifItem {
        if isSearching {
            return self.searchedGifs[indexPath.row]
        }
        return self.trendingGifs[indexPath.row]
    }
    
}
