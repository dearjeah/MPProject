//
//  StubMusicPlayerRepo.swift
//  MPProjectTests
//
//  Created by Delvina Janice on 02/07/24.
//

import XCTest
import RxSwift
@testable import MPProject

class StubMusicPlayerRepo: MusicPlayerRepo {
    func getAuth() -> Single<AuthModel> {
        return .error(HttpError.mockError())
    }
    
    func getToken() -> Single<TokenModel> {
        return .error(HttpError.mockError())
    }
    
    func getSearchTrack(query: String) -> Single<TracksSearchModel> {
        return .error(HttpError.mockError())
    }
    
}
