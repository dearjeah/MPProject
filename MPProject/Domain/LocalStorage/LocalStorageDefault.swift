//
//  LocalStorageDefault.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

struct LocalStorageDefault {
    public static var shared = LocalStorageDefault()
    private let defaults = UserDefaults.standard
    
    func setStorage(key: LocalStorageKey) {
        
        switch key {
        default:
            if let value = key.getValue() {
                defaults.set(value, forKey: key.getRawKey())
            } else {
                defaults.set(nil, forKey: key.getRawKey())
            }
        }
    }
    
    func getStorage(key: LocalStorageKey) -> Any? {
        switch key {
        default:
            guard let data = defaults.object(forKey: key.getRawKey())
            else { return nil }
            
            return data
        }
    }
    
    func removeLocalStorage(_ key: LocalStorageKey) {
        defaults.removeObject(forKey: key.getRawKey())
    }
    
    func removeAllLocalStorage() {
        self.removeLocalStorage(.accessToken(nil))
        self.removeLocalStorage(.resetTime(nil))
    }
    
    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
}
