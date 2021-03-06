//
//  YouTubeThumbnails.swift
//  YouTube
//
//  Created by Shai Ariman on 29/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import Foundation

extension YouTube {

    /**  Gets thumbnail image from DataCache. If not in cache, DataCache will try to download using  requestVideoThumbnail func. */
    public mutating func getVideoThumbnail(url : String, completion : @escaping (String, Data?) -> ()) {
        thumbnailsCache.getData(forKey: url) { data in
            completion(url, data)
        }
    }
    
    /**  To be injected into DataCache. Makes a request to download a thumbnail image. */
    internal func requestVideoThumbnail(url : String, completion : @escaping (String, Data?) -> ()) {

        guard let imageUrl = URL(string : url) else {
            completion(url, nil)
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { (data, URLResponse, error) in
            completion(url, data)
        }.resume()
    }
}
