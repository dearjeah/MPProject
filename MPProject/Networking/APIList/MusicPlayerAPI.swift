//
//  MusicPlayerAPI.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import Alamofire

public enum MusicPlayerAPI: APIConfiguration {
    case getAuth
    case getToken
    case getTracksList
    case getSearch(q: String)
    
    public var baseURL: String {
        switch self {
        case .getToken:
            return baseURLAuth
        default:
            return baseURLMusic
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getToken:
            return authHeader
        default:
            return defaultHeader
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getToken:
            return .post
        case .getTracksList,
                .getSearch,
                .getAuth:
            return .get
        }
    }
    
    public var path: String {
        switch self {
        case .getAuth:
            return "/authorize"
        case .getToken:
            return "/token"
        case .getTracksList:
            return "/tracks"
        case .getSearch:
            return "/search"
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .getAuth:
            return [
                "response_type": "code",
                "client_id": Constant.clientId,
                "redirect_uri": Constant.redirect_uri
            ]
        case .getToken:
            return ["grant_type": "client_credentials"]
        case .getTracksList:
            return [
                "ids": "client_credentials"
            ]
        case .getSearch(let query):
            return [
                "q": query,
                "type": "track"
            ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .getAuth,
                .getTracksList,
                .getSearch:
            return URLEncoding(destination: .queryString)
        default:
            return JSONEncoding.default
        }
    }
}
