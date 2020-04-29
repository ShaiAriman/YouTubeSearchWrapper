import Foundation

public struct YouTubeSearchResponse: Codable {
    public let kind, etag, nextPageToken, regionCode: String?
    public let pageInfo: PageInfo?
    public let items: [Item]?
}

public struct Item: Codable {
    public let kind: ItemKind?
    public let etag: String?
    public let id: ID?
    public let snippet: Snippet?
}

public struct ID: Codable {
    public let kind: IDKind?
    public let videoID, playlistID: String?

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
        case playlistID = "playlistId"
    }
}

public enum IDKind: String, Codable {
    case youtubePlaylist = "youtube#playlist"
    case youtubeVideo = "youtube#video"
}

public enum ItemKind: String, Codable {
    case youtubeSearchResult = "youtube#searchResult"
}

public struct Snippet: Codable {
    public let publishedAt: String?
    public let channelID: String?
    public let title, snippetDescription: String?
    public let thumbnails: Thumbnails?
    public let channelTitle: String?
    public let liveBroadcastContent: LiveBroadcastContent?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, liveBroadcastContent
    }
}

public enum LiveBroadcastContent: String, Codable {
    case none = "none"
}

public struct Thumbnails: Codable {
    public let thumbnailsDefault, medium, high: Default?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

public struct Default: Codable {
    public let url: String?
    public let width, height: Int?
}

public struct PageInfo: Codable {
    public let totalResults, resultsPerPage: Int?
}
