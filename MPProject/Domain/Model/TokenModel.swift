//
//  TokenModel.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

struct TokenModel: Codable, Equatable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
