//
//  MusicPlayerRepo.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import RxSwift

protocol MusicPlayerRepo {
    // Rx
    func getAuth() -> Single<AuthModel>
    func getToken() -> Single<TokenModel>
    func getSearchTrack(query: String) -> Single<TracksSearchModel>
}
    
final class MusicPlayerDefaultRepo: MusicPlayerRepo {
    func getAuth() -> Single<AuthModel> {
        APIClient.request(
            with: MusicPlayerAPI.getAuth,
            codable: AuthModel.self)
        .runInThread()
    }
    
    func getToken() -> Single<TokenModel> {
        APIClient.request(
            with: MusicPlayerAPI.getToken,
            codable: TokenModel.self)
        .runInThread()
    }
    
    func getSearchTrack(query: String) -> Single<TracksSearchModel> {
        APIClient.request(
            with: MusicPlayerAPI.getSearch(q: query),
            codable: TracksSearchModel.self)
        .runInThread()
    }
}
