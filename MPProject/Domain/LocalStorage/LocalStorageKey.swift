//
//  LocalStorageKey.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

enum LocalStorageKey {
    case accessToken(String?)
    case resetTime(Date?)
    
    func getRawKey() -> String {
        switch self {
        case .accessToken:
            return "access_token"
        case .resetTime:
            return "reset_time"
        }
    }
    
    func getValue() -> Any? {
        switch self {
        case .accessToken(let key):
            return key
        case .resetTime(let date):
            return date
        }
    }
}
