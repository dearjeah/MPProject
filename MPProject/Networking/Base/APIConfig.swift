//
//  APIConfig.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Alamofire
import Foundation

public typealias ParamString = [String: String]

public protocol APIConfiguration: URLRequestConvertible {
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
}

public enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case grantType = "grant_type"
}

public enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}


public extension APIConfiguration {

    // MARK: shortcuts
    var accessToken: String {
        let localStorage = LocalStorageDefault.shared
        let token = localStorage.getStorage(key: .accessToken(nil))
        return localStorage.stringFromAny(token).utf8EncodedString()
    }
    
    var auth: String {
        Constant.authCode
    }

    var baseURLAuth: String {
        "https://accounts.spotify.com/api"
    }
    
    var baseURLMusic: String {
        "https://api.spotify.com/v1"
    }

    // MARK: defaults

    var method: HTTPMethod {
        .get
    }
    
    var authHeader: [String: String] {
        let headers = [
            HTTPHeaderField.contentType.rawValue: ContentType.form.rawValue,
            HTTPHeaderField.authorization.rawValue: "Basic \(auth)",
            HTTPHeaderField.grantType.rawValue: "client_credentials"
        ]
        return headers
    }
    
    var defaultHeader: [String: String] {
       
        let headers = [
            HTTPHeaderField.contentType.rawValue: ContentType.form.rawValue,
            HTTPHeaderField.authorization.rawValue: "Bearer \(accessToken)" // user accessTokenn
        ]

        return headers
    }

    var parameters: Parameters? {
        nil
    }

    var parameterEncoding: ParameterEncoding {
        Alamofire.JSONEncoding.default
    }

    // MARK: utility

    func asURLRequest() throws -> URLRequest {
        let url = baseURL + path
        var urlRequest = URLRequest(url: URL(string: baseURL + path) ?? URL(string: baseURL)!)
        // MARK: - Cleaned URI if success
        if let uri = url.getCleanedURL() {
            urlRequest =  URLRequest(url: uri)
        }

        urlRequest.httpMethod = method.rawValue
        
        if baseURL == baseURLAuth {
            var requestBodyComponent = URLComponents()
            requestBodyComponent.queryItems = [
                URLQueryItem(name: "grant_type", value: "client_credentials")
            ]
            urlRequest.allHTTPHeaderFields = authHeader
            urlRequest.httpBody = requestBodyComponent.query?.data(using: .utf8)
            urlRequest.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        } else {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        print("urlReq", urlRequest)
        return try parameterEncoding.encode(urlRequest, with: parameters)
    }

    func getFullPath() -> String {
        return baseURL + path
    }
}
