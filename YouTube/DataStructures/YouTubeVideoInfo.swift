//
//  YouTubeVideoInfo.swift
//
//  Created by Shai Ariman on 27/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import Foundation

public struct YouTubeVideoInfo {
    public var id : String
    public var title : String
    public var thumbnainUrl : String
    public var publishedAt : String
    
    public var videoUrl : String {
        get {
            "https://www.youtube.com/watch?v=" + id
        }
    }
    
    public init(id : String, title : String, thumbnainUrl : String, publishedAt : String) {
        self.id = id
        self.title = title
        self.thumbnainUrl = thumbnainUrl
        self.publishedAt = publishedAt
    }
}
