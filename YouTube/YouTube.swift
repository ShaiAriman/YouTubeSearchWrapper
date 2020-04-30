//
//  YouTube.swift
//
//  Created by Shai Ariman on 27/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import Foundation
import DataCache

public struct YouTube {
    
    internal typealias YouTubeSearchRequestCompletionHandler = (YouTubeSearchResponse?, URLResponse?, Error?) -> Void
    public typealias YouTubeSearchCompletionHandler = ([YouTubeVideoInfo]?) -> Void
    
    internal lazy var thumbnailsCache = DataCache(requestDataHander: requestVideoThumbnail)
    
    private lazy var youTubeVideoInfos = [String : YouTubeVideoInfo]()
    
    private let apiKey : String
    
    public init(apiKey : String) {
        self.apiKey = apiKey
    }
    
    /** Makes a request to YouTube API to get latest videos for the channel. */
    internal func requestChannelVideos(channelId : String, maxResults : Int, completionHandler: @escaping YouTubeSearchRequestCompletionHandler) {
        if let url : URL = getSearchURLWith(apiKey : apiKey, channelId : channelId, maxResults : maxResults) {
            let youTubeSearchCodableTask = URLSession.shared.codableTask(with: url, completionHandler: completionHandler)
            youTubeSearchCodableTask.resume()
        }
    }
    
    /** Makes a request to YouTube API and prepares essential video info for the completion handler . */
    public func getChannelVideos(channelId : String, maxResults : Int, completionHandler: @escaping YouTubeSearchCompletionHandler) {
        
        let internalCompletionHandler : YouTubeSearchRequestCompletionHandler = { (youTubeSearchResponse, URLResponse, error) in
            
            var youTubeVideoInfo : [YouTubeVideoInfo]?
            
            if let youTubeResponse = youTubeSearchResponse,
                let items = youTubeResponse.items {
                
                youTubeVideoInfo = [YouTubeVideoInfo]()
                
                for item in items {
                    if let videoId = item.id?.videoID,
                        let snippet = item.snippet,
                        let title = snippet.title,
                        let thumbnailUrl = snippet.thumbnails?.medium?.url,
                        let publishedAt = snippet.publishedAt {
                        let videoInfo = YouTubeVideoInfo(id : videoId, title: title, thumbnainUrl: thumbnailUrl, publishedAt: publishedAt)
                        youTubeVideoInfo?.append(videoInfo)
                    }
                }
            }
            
            completionHandler(youTubeVideoInfo)
        }
        requestChannelVideos(channelId: channelId, maxResults: maxResults, completionHandler: internalCompletionHandler)
    }
    
    /**
     Prepares a YouTube API url with given parameters.
     - Example: https://www.googleapis.com/youtube/v3/search?key=&channelId=UC7ndkZ4vViKiM7kVEgdrlZQ&part=snippet,id&order=date&maxResults=20
     */
    private func getSearchURLWith(apiKey : String, channelId : String, maxResults : Int) -> URL? {
        let stringUrl = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&channelId=\(channelId)&part=snippet,id&order=date&maxResults=\(maxResults)"
        return URL(string: stringUrl)
    }
}
