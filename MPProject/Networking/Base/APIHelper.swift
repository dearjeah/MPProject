//
//  APIHelper.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

public struct Constant {
    public static var clientId = "46d52ef4192c4c54a2bdf0e8cf71117b"
    public static var clientSec = "d6dbee6cbbfb4975b91725cfbb96941e"
    public static var redirect_uri = "spotify-ios-quick-start://spotify-login-callback"
    public static var trackIds = ["7ouMYWpwJ422jRcDASZB7P",
                                  "4VqPOruhp5EdPBeR92t6lQ",
                                  "2takcwOaAZWiXQijPHIx7B",
                                  "3KosRTfZJFnErNBMF1ugua",
                                  "2lMQOAKPam2JVEfNsZtWDe",
                                  "7gaA3wERFkFkgivjwbSvkG",
                                  "3vkCueOmm7xQDoJ17W1Pm3",
                                  "6dpLxbF7lfCAnC9QRTjNLK",
                                  "0R6NfOiLzLj4O5VbYSJAjf",
                                  "1Iq8oo9XkmmvCQiGOfORiz",
                                  "4Ugf1uFzQx3RT7X0UgZjQv",
                                  "5XWlyfo0kZ8LF7VSyfS4Ew",
                                  "1qosh64U6CR5ki1g1Rf2dZ",
                                  "779jpZikRmH99DiSVpwCHD",
                                  "6odqveUIgvpWWvtANLcZpH",
                                  "03nSjRW0PS4yNdw16XXYLO"
    ]
}

public enum UIViewState: Equatable {
    case loading
    case error
    case finish
}
