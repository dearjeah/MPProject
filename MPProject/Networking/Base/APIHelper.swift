//
//  APIHelper.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

public struct Constant {
    public static var authCode = "NDZkNTJlZjQxOTJjNGM1NGEyYmRmMGU4Y2Y3MTExN2I6ZDZkYmVlNmNiYmZiNDk3NWI5MTcyNWNmYmI5Njk0MWU="
    public static var clientId = "46d52ef4192c4c54a2bdf0e8cf71117b"
    public static var clientSec = "d6dbee6cbbfb4975b91725cfbb96941e"
    public static var redirect_uri = "spotify-ios-quick-start://spotify-login-callback"
}

public enum UIViewState: Equatable {
    case loading
    case error
    case finish
}
