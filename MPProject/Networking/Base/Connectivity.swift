//
//  Connectivity.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import Alamofire

public final class Connectivity {
    public final class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
