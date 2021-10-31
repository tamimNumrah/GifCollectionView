//
//  TenorEnums.swift
//  GifCollectionView
//
//  Created by Tamim on 31/10/21.
//

import Foundation

enum TenorRequest: String {
    case search = "search"
    case trending = "trending"
    case registerShare = "registershare"
}

enum TenorContentFilter: String {
    case off = "off"
    case low = "low"
    case medium = "medium"
    case high = "high"
}

enum TenorMediaFilter: String {
    case minimal = "minimal"
    case basic = "basic"
}
