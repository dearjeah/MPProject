//
//  TrackModel.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation


struct TracksModel: Codable {
    var tracks: [Track]?
}

// MARK: - Track
struct Track: Codable {
    var album: Album?
    var artists: [TrackArtist]?
    var availableMarkets: [String]?
    var discNumber, durationMS: Int?
    var explicit: Bool?
    var externalIDS: ExternalIDS?
    var externalUrls: ExternalUrls?
    var href, id: String?
    var isPlayable: Bool?
    var restrictions: Restrictions?
    var name: String?
    var popularity: Int?
    var previewURL: String?
    var trackNumber: Int?
    var type, uri: String?
    var isLocal: Bool?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isPlayable = "is_playable"
        case restrictions, name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
        case isLocal = "is_local"
    }
}

// MARK: - Album
struct Album: Codable {
    var totalTracks: Int?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href, id: String?
    var images: [Image]?
    var name, releaseDate: String?
    var restrictions: Restrictions?
    var type, uri: String?
    var artists: [AlbumArtist]?

    enum CodingKeys: String, CodingKey {
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case restrictions, type, uri, artists
    }
}

// MARK: - AlbumArtist
struct AlbumArtist: Codable {
    var externalUrls: ExternalUrls?
    var href, id, name, type: String?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    var spotify: String?
}

// MARK: - Image
struct Image: Codable {
    var url: String?
    var height, width: Int?
}

// MARK: - Restrictions
struct Restrictions: Codable {
    var reason: String?
}

// MARK: - TrackArtist
struct TrackArtist: Codable {
    var externalUrls: ExternalUrls?
    var followers: Followers?
    var genres: [String]?
    var href, id: String?
    var images: [Image]?
    var name: String?
    var popularity: Int?
    var type, uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: - Followers
struct Followers: Codable {
    var href: String?
    var total: Int?
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    var isrc, ean, upc: String?
}
