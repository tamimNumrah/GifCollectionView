//
//  TenorAPIManager.swift
//  GifCollectionView
//
//  Created by Tamim on 30/10/21.
//

import Foundation
import SwiftyJSON

public typealias loadGifsRequestCompletion = (_ success: Bool, _ gifs: [TenorGifItem]?, _ searchText: String?, _ position: String?) -> ()
public typealias anonymousIdCompletionHanlder = (_ success: Bool, _ anonymousID: String?) -> ()

let TenorBaseURL = "https://g.tenor.com/v1/"
let TenorAnynymousIDUserDefaultKey = "TenorAnynymousIDUserDefaultKey"
let TenorResponseAnonIdJsonKey = "anonId"

class TenorAPIManager {
    private var tenorURLGenerator: TenorURLGenerator
    
    init(tenorApiKey: String) {
        tenorURLGenerator = TenorURLGenerator.init(apiKey: tenorApiKey)
        setAnonymousId()
    }
    
    func loadGifs(searchText: String?, position: String?, completionHandler: @escaping loadGifsRequestCompletion) {
        let loadGifsRequest = URLRequest.init(url: tenorURLGenerator.tenorGifEndpoint(text: searchText, position: position))
        self.makeWebRequest(urlRequest: loadGifsRequest) { success, jsonObject in
            if success, let json = jsonObject{
                let position = json["next"].stringValue
                var gifItems = [TenorGifItem]()
                if let results = json["results"].array {
                    gifItems = TenorGifItem.gifsFromResponse(jsonData: results)
                    
                }
                completionHandler(true, gifItems, searchText, position)
                
            } else {
                completionHandler(false, nil, searchText, position)
            }
        }
    }
    
    
}

extension TenorAPIManager {
    fileprivate func setAnonymousId() {
        if let anonymousId = UserDefaults.standard.string(forKey: TenorAnynymousIDUserDefaultKey) {
            tenorURLGenerator.anonymousId = anonymousId
        } else {
            self.anonymousIDRequest { [weak self] success, anonymousID in
                if let anonId = anonymousID {
                    UserDefaults.standard.set(anonId, forKey: TenorAnynymousIDUserDefaultKey)
                    UserDefaults.standard.synchronize()
                    self?.tenorURLGenerator.anonymousId = anonId
                } else {
                    fatalError("Anonymous Id could not be retrieved") //TODO
                }
            }
        }
    }
    
    fileprivate func anonymousIDRequest(completionHandler: anonymousIdCompletionHanlder?){
        let anonymousIDRequest = URLRequest(url: tenorURLGenerator.TenorAnonIdEndpoint())
        makeWebRequest(urlRequest: anonymousIDRequest, completionHandler: { success, json in
            if success, let json = json{
                let anonId = json[TenorResponseAnonIdJsonKey].string
                completionHandler?(true, anonId)
            }else{
                completionHandler?(false, nil)
            }
        })
    }
    
    fileprivate func makeWebRequest(urlRequest: URLRequest, completionHandler: @escaping (_ success: Bool, _ jsonObject: JSON?) -> ()) {
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                if data == nil{
                    print(error?.localizedDescription ?? "")
                    completionHandler(false, nil)
                    return
                }
                let json = try JSON(data: data!)
                completionHandler(true, json)
            } catch let error as NSError {
                print(error.localizedDescription)
                completionHandler(false, nil)
            }
        }
        task.resume()
    }
}
