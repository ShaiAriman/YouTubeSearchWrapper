//
//  YouTubeTests.swift
//  YouTubeTests
//
//  Created by Shai Ariman on 27/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import XCTest
@testable import YouTube

class YouTubeTests: XCTestCase {

    func testResponseFromFromFile() {

        let testBundle = Bundle(for: type(of: self))
        
        guard let content = testBundle.url(forResource: "YouTubeSearchResponse", withExtension: "json") else {
                XCTFail()
                return
            }
        
        guard let data: Data = NSData(contentsOf: content) as Data? else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try? decoder.decode(YouTubeSearchResponse.self, from: data)
        
        XCTAssert(response != nil)
        XCTAssert(response?.items?.count == 20)
    }
    
    // example:  "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAGSd9LGn9XVC1rUJAuPFbcOQpEwZIbq8A&channelId=UC7ndkZ4vViKiM7kVEgdrlZQ&part=snippet,id&order=date&maxResults=20"
    func testYouTubeSearchRequests() throws {
        testYouTubeSearchNoError(apiKey: "AIzaSyAGSd9LGn9XVC1rUJAuPFbcOQpEwZIbq8A", channelId: "UC7ndkZ4vViKiM7kVEgdrlZQ", maxResults: 20)
    }

    
    func testGetYouTubeSearch() throws {
        testGetYouTubeSearch(apiKey: "AIzaSyAGSd9LGn9XVC1rUJAuPFbcOQpEwZIbq8A", channelId: "UC7ndkZ4vViKiM7kVEgdrlZQ", maxResults: 20)
    }
    
    func testYouTubeSearchNoError(apiKey : String, channelId : String, maxResults : Int) {
        
        var resonseReceived = false
        var receivedError : Error?
        var receivedYouTubeSearchResponse : YouTubeSearchResponse?
        
        YouTube(apiKey: apiKey).requestChannelVideos(channelId: channelId, maxResults: maxResults, completionHandler: {(youTubeSearchResponse, URLResponse, error) in
            
            receivedError = error
            receivedYouTubeSearchResponse = youTubeSearchResponse
            
            resonseReceived = true
        })
        
        let msToWait = 20 * 1000
        var numberOfIntervalsUntilTimeout = 1000 //number of msToWait until test fails
        
        // Wait until response arrives
        while !resonseReceived {
            numberOfIntervalsUntilTimeout -= 1
            XCTAssert(numberOfIntervalsUntilTimeout > 0, "Request took too much time")
            
            usleep(useconds_t(msToWait)) //will sleep for 2 milliseconds (.002 seconds)
        }
        
        XCTAssert(receivedError == nil)
        XCTAssert(receivedYouTubeSearchResponse != nil)
        XCTAssert(receivedYouTubeSearchResponse!.items != nil)
        XCTAssert(receivedYouTubeSearchResponse!.items!.count <= maxResults)
    }
    
    func testGetYouTubeSearch(apiKey : String, channelId : String, maxResults : Int) {
        
        var resonseReceived = false
        
        var receivedVideoInfos : [YouTubeVideoInfo]?
        
        YouTube(apiKey: apiKey).getChannelVideos(channelId: channelId, maxResults: maxResults, completionHandler: { videoInfos in
            
            receivedVideoInfos = videoInfos
            
            resonseReceived = true
        })
        
        let msToWait = 20 * 1000
        var numberOfIntervalsUntilTimeout = 1000 //number of msToWait until test fails
        
        // Wait until response arrives
        while !resonseReceived {
            numberOfIntervalsUntilTimeout -= 1
            XCTAssert(numberOfIntervalsUntilTimeout > 0, "Request took too much time")
            
            usleep(useconds_t(msToWait)) //will sleep for 2 milliseconds (.002 seconds)
        }
        
        XCTAssert(receivedVideoInfos != nil)
        XCTAssert(receivedVideoInfos!.count <= maxResults)
    }
}
