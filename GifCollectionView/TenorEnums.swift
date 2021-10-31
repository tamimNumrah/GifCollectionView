//
//  TenorEnums.swift
//  GifCollectionView
//
//  Created by Tamim on 31/10/21.
//

import Foundation

/// Tenor Endpoints
enum TenorEndpointType: String {
    /// Search - Get a json object containing a list of the most relevant GIFs for a given search term(s), category(ies), emoji(s), or any combination thereof.
    case search = "search"
    
    /// Trending GIFs - Get a json object containing a list of the current global trending GIFs. The trending stream is updated regularly throughout the day.
    case trending = "trending"
    
    /// Categories - Get a json object containing a list of GIF categories associated with the provided type. Each category will include a corresponding search URL to be used if the user clicks on the category. The search URL will include the apikey, anonymous id, and locale that were used on the original call to the categories endpoint.
    case categories = "categories"
    
    /// Register Share - Register a user’s sharing of a GIF.
    case registershare = "registershare"
    
    /// Search Suggestions - Get a json object containing a list of alternative search terms given a search term.
    case search_suggestions = "search_suggestions"
    
    /// Autocomplete - Get a json object containing a list of completed search terms given a partial search term. The list is sorted by Tenor’s AI and the number of results will decrease as Tenor’s AI becomes more certain.
    case autocomplete = "autocomplete"
    
    /// Trending Search Terms - Get a json object containing a list of the current trending search terms. The list is updated Hourly by Tenor’s AI.
    case trending_terms = "trending_terms"
    
    /// GIFs - Get the GIF(s) for the corresponding id(s)
    case gifs = "gifs"
    
    /// Random GIFs - Get a randomized list of GIFs for a given search term. This differs from the search endpoint which returns a rank ordered list of GIFs for a given search term.
    case random = "random"
    
    /// Anonymous ID  - Get an anonymous ID for a new user. Store the ID in the client’s cache for use on any additional API calls made by the user, either in this session or any future sessions.
    case anonid = "anonid"
}

/// Specify the content safety filter level
enum TenorContentFilter: String {
    /// Content safety filter level off
    case off = "off"
    /// Content safety filter level low
    case low = "low"
    /// Content safety filter level medium
    case medium = "medium"
    /// Content safety filter level high
    case high = "high"
}

/// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
enum TenorMediaFilter: String {
    /// Will return tinygif, gif, and mp4
    case minimal = "minimal"
    /// Will return nanomp4, tinygif, tinymp4, gif, mp4, and nanogif
    case basic = "basic"
}

/// Filter the response GIF_OBJECT list to only include GIFs with aspect ratios that fit with in the selected range.
enum TenorAspectRatio: String {
    /// No aspect ratio constraints
    case all = "all"
    /// Aspect ratio range from 0.42 to 2.36
    case wide = "wide"
    /// Aspect ratio range from .56 to 1.78
    case standard = "standard"
}

/// Determines the type of categories returned
enum TenorCategoryType: String {
    /// Category type featured
    case featured = "featured"
    /// Category type emoji
    case emoji = "emoji"
    /// Category type trending
    case trending = "trending"
}
