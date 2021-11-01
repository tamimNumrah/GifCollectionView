//
//  TenorEndpoints.swift
//  GifCollectionView
//
//  Created by Tamim on 31/10/21.
//

import Foundation
import SwiftyJSON

/// Get a json object containing a list of the most relevant GIFs for a given search term(s), category(ies), emoji(s), or any combination thereof.
public struct TenorEndpointSearch: TenorEndpoint {
    public typealias json = JSON
    
    public typealias response = (next: String, results: [TenorGifItem])
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .search
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?q=\(q)&key=\(key)&locale=\(locale)&contentfilter=\(contentFilter.rawValue)&ar_range=\(ar_range.rawValue)&limit=\(limit)"
        
        if let media_filter = media_filter {
            baseURL += "&media_filter=\(media_filter)"
        }
        
        if let pos = pos {
            baseURL += "&pos=\(pos)"
        }
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the content safety filter level
    var contentFilter: TenorContentFilter = .off
    
    /// Filter the response GIF_OBJECT list to only include GIFs with aspect ratios that fit with in the selected range.
    var ar_range: TenorAspectRatio = .all
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
    var media_filter: String? = nil
    
    /// Get results starting at position "value". Use a non-zero "next" value returned by API results to get the next set of results. pos is not an index and may be an integer, float, or string
    var pos: String? = nil
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// next - a position identifier to use with the next API query to retrieve the next set of results, or 0 if there are no further results.
    /// results - an array of GIF_OBJECTS containing the most relevant GIFs for the requested search term - Sorted by relevancy Rank
    public func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a json object containing a list of the current global trending GIFs. The trending stream is updated regularly throughout the day.
public struct TenorEndpointTrending: TenorEndpoint {
    public typealias json = JSON
    
    public typealias response = (next: String, results: [TenorGifItem])
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .trending
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?key=\(key)&locale=\(locale)&contentfilter=\(contentFilter.rawValue)&ar_range=\(ar_range.rawValue)&limit=\(limit)"
        
        if let media_filter = media_filter {
            baseURL += "&media_filter=\(media_filter)"
        }
        
        if let pos = pos {
            baseURL += "&pos=\(pos)"
        }
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the content safety filter level
    var contentFilter: TenorContentFilter = .off
    
    /// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
    var media_filter: String? = nil
    
    /// Filter the response GIF_OBJECT list to only include GIFs with aspect ratios that fit with in the selected range.
    var ar_range: TenorAspectRatio = .all
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Get results starting at position "value". Use a non-zero "next" value returned by API results to get the next set of results. pos is not an index and may be an integer, float, or string
    var pos: String? = nil
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// next - a position identifier to use with the next API query to retrieve the next set of results, or 0 if there are no further results.
    /// results - an array of Trending GIF_OBJECTS sorted by Trending Rank
    public func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a json object containing a list of GIF categories associated with the provided type. Each category will include a corresponding search URL to be used if the user clicks on the category. The search URL will include the apikey, anonymous id, and locale that were used on the original call to the categories endpoint.
public struct TenorEndpointCategories: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = [JSON]
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .categories
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?key=\(key)&locale=\(locale)&contentfilter=\(contentFilter.rawValue)&type=\(type.rawValue)"
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the content safety filter level
    var contentFilter: TenorContentFilter = .off
    
    /// Determines the type of categories returned
    var type: TenorCategoryType = .featured
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// an array of CATEGORY_OBJECTS where the “name” field has been translated to the passed in locale language.
    public func responseExtractor(_ json: JSON) -> [JSON] {
        if let tags = json["tags"].array {
            return tags
        }
        return [JSON]()
    }
}

/// Get a json object containing a list of alternative search terms given a search term.
public struct TenorEndpointSearchSuggestions: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = [String]
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .search_suggestions
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?q=\(q)&key=\(key)&locale=\(locale)&limit=\(limit)"
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms.
    public func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Get a json object containing a list of completed search terms given a partial search term. The list is sorted by Tenor’s AI and the number of results will decrease as Tenor’s AI becomes more certain.
public struct TenorEndpointAutocomplete: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = [String]
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .autocomplete
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?q=\(q)&key=\(key)&locale=\(locale)&limit=\(limit)"
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms.
    public func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Get a json object containing a list of the current trending search terms. The list is updated Hourly by Tenor’s AI.
public struct TenorEndpointTrendingSearchTerms: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = [String]
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .trending_terms
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?key=\(key)&locale=\(locale)&limit=\(limit)"
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms. Sorted by Trending Rank.
    public func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Register a user’s sharing of a GIF.
public struct TenorEndpointRegisterShare: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = String
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .registershare
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?id=\(id)&key=\(key)&locale=\(locale)"
        
        if let q = q {
            baseURL += "&q=\(q)"
        }
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// the “id” of a GIF_OBJECT
    var id: String
    
    /// The search string that lead to this share
    var q: String?
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// set to “ok” if share registration was successful
    public func responseExtractor(_ json: JSON) -> String {
        return json["status"].stringValue
    }
}

/// Get the GIF(s) for the corresponding id(s)
public struct TenorEndpointGIFs: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = (next: String, results: [TenorGifItem])
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .gifs
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?ids=\(ids)&key=\(key)&limit=\(limit)"
        
        if let media_filter = media_filter {
            baseURL += "&media_filter=\(media_filter)"
        }
        
        if let pos = pos {
            baseURL += "&pos=\(pos)"
        }
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// a comma separated list of GIF IDs (max: 50)
    var ids: String
    
    /// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
    var media_filter: String? = nil
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Get results starting at position "value". Use a non-zero "next" value returned by API results to get the next set of results. pos is not an index and may be an integer, float, or string
    var pos: String? = nil
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// next - a position identifier to use with the next API query to retrieve the next set of results, or 0 if there are no further results.
    /// results - an array of GIF_OBJECTS corresponding to the passed in GIF id list
    public func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a randomized list of GIFs for a given search term. This differs from the search endpoint which returns a rank ordered list of GIFs for a given search term.
public struct TenorEndpointRandomSearch: TenorEndpoint {
    public typealias json = JSON
    
    public typealias response = (next: String, results: [TenorGifItem])
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .random
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?q=\(q)&key=\(key)&locale=\(locale)&contentfilter=\(contentFilter.rawValue)&ar_range=\(ar_range.rawValue)&limit=\(limit)"
        
        if let media_filter = media_filter {
            baseURL += "&media_filter=\(media_filter)"
        }
        
        if let pos = pos {
            baseURL += "&pos=\(pos)"
        }
        
        if let anon_id = anon_id {
            baseURL += "&anon_id=\(anon_id)"
        }
        
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the content safety filter level
    var contentFilter: TenorContentFilter = .off
    
    /// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
    var media_filter: String? = nil
    
    /// Filter the response GIF_OBJECT list to only include GIFs with aspect ratios that fit with in the selected range.
    var ar_range: TenorAspectRatio = .all
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Get results starting at position "value". Use a non-zero "next" value returned by API results to get the next set of results. pos is not an index and may be an integer, float, or string
    var pos: String? = nil
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// next - a position identifier to use with the next API query to retrieve the next set of results, or 0 if there are no further results.
    /// results - an array of GIF_OBJECTS containing the most relevant GIFs for the requested search term - Sorted by relevancy Rank
    public func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get an anonymous ID for a new user. Store the ID in the client’s cache for use on any additional API calls made by the user, either in this session or any future sessions.
public struct TenorEndpointAnonymousID: TenorEndpoint {
    
    public typealias json = JSON
    
    public typealias response = String
    
    public var key: String
    
    public var endpointType: TenorEndpointType = .anonid
    
    public func url() -> URL {
        var baseURL = TenorBaseURL + endpointType.rawValue
        baseURL += "?key=\(key)"
        return URL(string: baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    /// an anonymous id used to represent a user. This allows for tracking without the use of personally identifiable information
    public func responseExtractor(_ json: JSON) -> String {
        return json["anon_id"].stringValue
    }
}
