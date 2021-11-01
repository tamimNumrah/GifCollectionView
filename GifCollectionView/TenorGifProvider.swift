//
//  TenorGifProvider.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import Foundation

final class TenorGifProvider: GifProvider {
    private var apiKey: String?
    private var anonymousID: String?
    
    private var lastSearchString: String?
    private var isSearching: Bool = false
    
    private var searchedGifs = [TenorGifItem]()
    private var trendingGifs =  [TenorGifItem]()
    
    private var lastPositionForTrending: String?
    private var lastPositionForSearch: String?
    
    private var apiManager: TenorAPIManager!
    
    func setApiKey(apiKey: String) {
        self.apiKey = apiKey
        self.apiManager = TenorAPIManager()
        self.setAnonymousId()
    }
    
    
    func startLoadingGifs(with text: String?, completion: @escaping (_ success: Bool) -> Void) {
        if self.apiKey == nil {
            fatalError("API Key isn't set. TenorGifProvider couldn't be loaded")
        }
        if let searchText = text {
            self.isSearching = true
            let search = TenorEndpointSearch.init(key: self.apiKey!, q: searchText, anon_id: self.anonymousID)
            self.apiManager.makeTenorWebRequest(endpoint: search) { [weak self] success, response in
                guard let self = self else { return }
                if success {
                    self.lastPositionForSearch = response?.next
                    self.searchedGifs = response?.results ?? [TenorGifItem]()
                    self.lastSearchString = searchText
                }
                completion(success)
            }
        } else {
            self.isSearching = false
            if trendingGifs.isEmpty {
                let trending = TenorEndpointTrending.init(key: self.apiKey!, anon_id: self.anonymousID)
                self.apiManager.makeTenorWebRequest(endpoint: trending) { [weak self] success, response in
                    guard let self = self else { return }
                    if success {
                        self.lastPositionForTrending = response?.next
                        self.trendingGifs = response?.results ?? [TenorGifItem]()
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
                guard let lastSearchString = self.lastSearchString else {
                    print("LastSearchString is nil..Cannot load more GIFs")
                    completion(false, [IndexPath]())
                    return
                }
                let search = TenorEndpointSearch.init(key: self.apiKey!, q: lastSearchString, pos: lastPositionForSearch, anon_id: self.anonymousID)
                self.apiManager.makeTenorWebRequest(endpoint: search) { [weak self] success, response in
                    guard let self = self else { return }
                    if success, let response = response {
                        self.lastPositionForSearch = response.next
                        var searchedGifsCount = self.searchedGifs.count
                        var indexPaths = [IndexPath]()
                        for gif in response.results {
                            self.searchedGifs.append(gif)
                            indexPaths.append(IndexPath.init(row: searchedGifsCount, section: 0))
                            searchedGifsCount += 1
                        }
                        completion(true, indexPaths)
                    } else {
                        completion(false, [IndexPath]())
                    }
                }
            }
        } else {
            if lastPositionForTrending == nil || lastPositionForTrending == "0" {
                completion(false, [IndexPath]())
            } else {
                let trending = TenorEndpointTrending.init(key: self.apiKey!, pos: lastPositionForTrending, anon_id: self.anonymousID)
                self.apiManager.makeTenorWebRequest(endpoint: trending) { [weak self] success, response in
                    guard let self = self else { return }
                    if success, let response = response {
                        self.lastPositionForTrending = response.next
                        var searchedGifsCount = self.trendingGifs.count
                        var indexPaths = [IndexPath]()
                        for gif in response.results {
                            self.trendingGifs.append(gif)
                            indexPaths.append(IndexPath.init(row: searchedGifsCount, section: 0))
                            searchedGifsCount += 1
                        }
                        completion(true, indexPaths)
                    } else {
                        completion(false, [IndexPath]())
                    }
                }

            }
        }
    }
    
    func registerShare(gifItem: GifItem) {
        let share = TenorEndpointRegisterShare.init(key: self.apiKey!, id: gifItem.gifID)
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

extension TenorGifProvider {
    fileprivate func setAnonymousId() {
        if let anonymousId = UserDefaults.standard.string(forKey: TenorAnynymousIDUserDefaultKey) {
            self.anonymousID = anonymousId
        } else {
            let anonId = TenorEndpointAnonymousID.init(key: self.apiKey!)
            self.apiManager.makeTenorWebRequest(endpoint: anonId) { [weak self] success, response in
                guard let self = self else { return }
                if success, let anonId = response{
                    UserDefaults.standard.set(anonId, forKey: TenorAnynymousIDUserDefaultKey)
                    UserDefaults.standard.synchronize()
                    self.anonymousID = anonId
                }
            }
        }
    }
}
