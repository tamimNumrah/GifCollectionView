//
//  TenorGifItem.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import Foundation
import UIKit
import SwiftyJSON

public final class TenorGifItem: GifItem, Codable{
    public fileprivate(set) var gifItemURL: URL
    public fileprivate(set) var simpleURL: URL

    public fileprivate(set) var gifItemSize: CGSize
    public fileprivate(set) var gifID: String = ""
    
    public fileprivate(set) var tinyGifWidth: Int
    public fileprivate(set) var tinyGifHeight: Int
    public fileprivate(set) var tinyGifPreviewURL: URL
    public fileprivate(set) var tinyGifURL: URL
    public fileprivate(set) var tinyGifSize: Int
    
    
    public fileprivate(set) var regularGifWidth: Int
    public fileprivate(set) var regularGifHeight: Int
    public fileprivate(set) var regularGifPreviewURL: URL
    public fileprivate(set) var regularGifURL: URL
    public fileprivate(set) var regularGifSize: Int

    init(_ jsonObject: JSON) {
        //gifItemURL = URL(string: jsonObject["itemurl"].stringValue)!
        simpleURL = URL(string: jsonObject["url"].stringValue)!
        gifID = jsonObject["id"].stringValue
        
        let media = jsonObject["media"].arrayValue[0]
        
        let tinyGif = media["tinygif"]
        tinyGifPreviewURL = URL(string: tinyGif["preview"].stringValue)!
        tinyGifURL = URL(string: tinyGif["url"].stringValue)!
        tinyGifSize = tinyGif["size"].intValue
        
        let tinyGifDimension = tinyGif["dims"].arrayObject as! [Int]
        tinyGifWidth = tinyGifDimension[0]
        tinyGifHeight = tinyGifDimension[1]
        
        let regularGif = media["gif"]
        regularGifPreviewURL = URL(string: regularGif["preview"].stringValue)!
        regularGifURL = URL(string: regularGif["url"].stringValue)!
        gifItemURL = URL(string: regularGif["url"].stringValue)!
        regularGifSize = regularGif["size"].intValue
        
        let regularGifDimension = regularGif["dims"].arrayObject as! [Int]
        regularGifWidth = regularGifDimension[0]
        regularGifHeight = regularGifDimension[1]
        
        gifItemSize = CGSize.init(width: tinyGifWidth, height: tinyGifHeight)
    }
    
    static func gifsFromResponse(jsonData: [JSON]) -> [TenorGifItem] {
        var gifItems = [TenorGifItem]()
        for response in jsonData{
            //get the gif and store it in gif items array
            let tenorGifItem = TenorGifItem.init(response)
            gifItems.append(tenorGifItem)
        }
        return gifItems
    }
}
