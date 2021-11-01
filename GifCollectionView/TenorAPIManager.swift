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

public final class TenorAPIManager {
    func makeTenorWebRequest<T: TenorEndpoint>(endpoint: T, completionHandler: @escaping (_ success: Bool, _ response: T.response?) -> ()) {
        let loadGifsRequest = URLRequest.init(url: endpoint.url())
        self.makeWebRequest(urlRequest: loadGifsRequest) { success, jsonObject in
            if success, let json = jsonObject as? T.json{
                let response = endpoint.responseExtractor(json)
                completionHandler(success, response)
            } else {
                completionHandler(success, nil)
            }
        }
    }
}

extension TenorAPIManager {
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
