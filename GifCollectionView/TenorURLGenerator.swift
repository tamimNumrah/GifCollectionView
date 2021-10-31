//
//  TenorURLGenerator.swift
//  GifCollectionView
//
//  Created by Tamim on 31/10/21.
//

import Foundation

struct TenorURLGenerator {
    var locale = "en_US"
    var mediaFilter: TenorMediaFilter = .minimal
    var contentFilter: TenorContentFilter = .off
    var limit: Int = 20
    
    var apiKey: String
    var anonymousId: String = ""
    
    func TenorAnonIdEndpoint() -> URL{
        let urlString = TenorBaseURL + "anonid?key=\(apiKey)"
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    func tenorGifEndpoint(text: String?, position: String?) -> URL{
        var tenorRequest: TenorRequest = .trending
        var baseURL = TenorBaseURL
        if let searchText = text {
            tenorRequest = .search
            baseURL += "\(tenorRequest.rawValue)?q=\(searchText)&"
        } else {
            baseURL += "\(tenorRequest.rawValue)?"
        }
        
        baseURL += "key=\(apiKey)&anon_id=\(anonymousId)&limit=\(limit)&locale=\(locale)&media_filter=\(mediaFilter.rawValue)&contentfilter=\(contentFilter.rawValue)"
        
        if let pos = position{
            baseURL += "&pos=\(pos)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    func registerShareEndpoint(gifID: String, searchText: String) -> URL{
        var baseURL = TenorBaseURL
        baseURL += "\(TenorRequest.registerShare.rawValue)?"
        baseURL += "key=\(apiKey)&anon_id=\(anonymousId)&q=\(searchText)&locale=\(locale)"

        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
}
