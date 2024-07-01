//
//  TrackSearchModel.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

struct TracksSearchModel: Codable {
    var tracks: Tracks?
}

struct Tracks: Codable {
    var href: String?
    var items: [Track]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var total: Int?
}

extension TracksSearchModel {
    static var localSong: Self {
        .init(tracks: .init(
            items: [
                Track(album: Album(name: "Hari Baru"),
                      artists: [TrackArtist( name: "RAN")],
                      durationMS: 0,
                      id: "LS001",
                      name: "Dekat Di Hati",
                      trackNumber: 1,
                      type: "track",
                      uri: "RAN_Dekat_di_Hati"),
                Track(album: Album(name: "Speak Now"),
                      artists: [TrackArtist( name: "Taylor Swift")],
                      durationMS: 0,
                      id: "LS002",
                      name: "Back To December",
                      trackNumber: 2,
                      type: "track",
                      uri: "Taylor_Swift _Back_To_December"),
                Track(album: Album(name: "÷"),
                      artists: [TrackArtist( name: "Ed Sheeran")],
                      durationMS: 0,
                      id: "LS003",
                      name: "Perfect",
                      trackNumber: 3,
                      type: "track",
                      uri: "Ed_Sheeran_Perfect"),
                Track(album: Album(name: "Dengar Alam Bernyanyi"),
                      artists: [TrackArtist( name: "HIVI")],
                      durationMS: 0,
                      id: "LS004",
                      name: "Dengar Alam Bernyanyi",
                      trackNumber: 4,
                      type: "track",
                      uri: "Hivi_DENGAR _ALAM_BERNYANYI"),
                Track(album: Album(name: "Meteora (20th Anniversary Edition)"),
                      artists: [TrackArtist( name: "Linkin Park")],
                      durationMS: 0,
                      id: "LS005",
                      name: "Fighting Myself",
                      trackNumber: 5,
                      type: "track",
                      uri: "Linkin_Park_Fighting_Myself")
            ],
            total: 5)
        )
    }
}
