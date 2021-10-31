//
//  TenorEndpoints.swift
//  GifCollectionView
//
//  Created by Tamim on 31/10/21.
//

import Foundation
import SwiftyJSON

/// Get a json object containing a list of the most relevant GIFs for a given search term(s), category(ies), emoji(s), or any combination thereof.
struct TenorEndpointSearch: TenorEndpoint {
    typealias json = JSON
    
    typealias response = (next: String, results: [TenorGifItem])
    
    var key: String
    
    var endpointType: TenorEndpointType = .search
    
    var url: URL
    
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
    func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a json object containing a list of the current global trending GIFs. The trending stream is updated regularly throughout the day.
struct TenorEndpointTrending: TenorEndpoint {
    typealias json = JSON
    
    typealias response = (next: String, results: [TenorGifItem])
    
    var key: String
    
    var endpointType: TenorEndpointType = .trending
    
    var url: URL
    
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
    func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a json object containing a list of GIF categories associated with the provided type. Each category will include a corresponding search URL to be used if the user clicks on the category. The search URL will include the apikey, anonymous id, and locale that were used on the original call to the categories endpoint.
struct TenorEndpointCategories: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = [JSON]
    
    var key: String
    
    var endpointType: TenorEndpointType = .categories
    
    var url: URL
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the content safety filter level
    var contentFilter: TenorContentFilter = .off
    
    /// Determines the type of categories returned
    var type: TenorCategoryType = .featured
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// an array of CATEGORY_OBJECTS where the “name” field has been translated to the passed in locale language.
    func responseExtractor(_ json: JSON) -> [JSON] {
        if let tags = json["tags"].array {
            return tags
        }
        return [JSON]()
    }
}

/// Get a json object containing a list of alternative search terms given a search term.
struct TenorEndpointSearchSuggestions: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = [String]
    
    var key: String
    
    var endpointType: TenorEndpointType = .search_suggestions
    
    var url: URL
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms.
    func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Get a json object containing a list of completed search terms given a partial search term. The list is sorted by Tenor’s AI and the number of results will decrease as Tenor’s AI becomes more certain.
struct TenorEndpointAutocomplete: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = [String]
    
    var key: String
    
    var endpointType: TenorEndpointType = .autocomplete
    
    var url: URL
    
    /// A search string
    var q: String
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms.
    func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Get a json object containing a list of the current trending search terms. The list is updated Hourly by Tenor’s AI.
struct TenorEndpointTrendingSearchTerms: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = [String]
    
    var key: String
    
    var endpointType: TenorEndpointType = .trending_terms
    
    var url: URL
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Fetch up to a specified number of results (max: 50).
    var limit: Int = 20
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// An array of suggested search terms. Sorted by Trending Rank.
    func responseExtractor(_ json: JSON) -> [String] {
        if let results = json["results"].array as? [String] {
            return results
        }
        return [String]()
    }
}

/// Register a user’s sharing of a GIF.
struct TenorEndpointRegisterShare: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = String
    
    var key: String
    
    var endpointType: TenorEndpointType = .registershare
    
    var url: URL
    
    /// the “id” of a GIF_OBJECT
    var id: String
    
    /// The search string that lead to this share
    var q: String?
    
    /// Specify default language to interpret search string; xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1 country code
    var locale: String = "en_US"
    
    /// Specify the anonymous_id tied to the given user
    var anon_id: String? = nil
    
    /// set to “ok” if share registration was successful
    func responseExtractor(_ json: JSON) -> String {
        return json["status"].stringValue
    }
}

/// Get the GIF(s) for the corresponding id(s)
struct TenorEndpointGIFs: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = (next: String, results: [TenorGifItem])
    
    var key: String
    
    var endpointType: TenorEndpointType = .gifs
    
    var url: URL
    
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
    func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get a randomized list of GIFs for a given search term. This differs from the search endpoint which returns a rank ordered list of GIFs for a given search term.
struct TenorEndpointRandomSearch: TenorEndpoint {
    typealias json = JSON
    
    typealias response = (next: String, results: [TenorGifItem])
    
    var key: String
    
    var endpointType: TenorEndpointType = .random
    
    var url: URL
    
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
    func responseExtractor(_ json: JSON) -> (next: String, results: [TenorGifItem]) {
        let position = json["next"].stringValue
        var gifItems = [TenorGifItem]()
        if let results = json["results"].array {
            gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
            
        }
        return (position, gifItems)
    }
}

/// Get an anonymous ID for a new user. Store the ID in the client’s cache for use on any additional API calls made by the user, either in this session or any future sessions.
struct TenorEndpointAnonymousID: TenorEndpoint {
    
    typealias json = JSON
    
    typealias response = String
    
    var key: String
    
    var endpointType: TenorEndpointType = .anonid
    
    var url: URL
    
    /// an anonymous id used to represent a user. This allows for tracking without the use of personally identifiable information
    func responseExtractor(_ json: JSON) -> String {
        return json["anon_id"].stringValue
    }
}
