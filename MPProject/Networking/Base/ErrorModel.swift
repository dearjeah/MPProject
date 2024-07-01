//
//  ErrorModel.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

public struct ErrorModel: Codable, Equatable {
    var error: Bool?
    var status: Int?
    var message, description: String?
    
    public init(error: Bool?, status: Int?, message: String?, description: String?) {
        self.error = error
        self.status = status
        self.message = message
        self.description = description
    }
}

public class HttpError: Error, Equatable {
    public var errorBody: ErrorModel?
    
    public init(errorBody: ErrorModel?) {
        self.errorBody = errorBody
    }
    
    public static var noConnectionError = HttpError(
        errorBody: ErrorModel(error: true,
                              status: 0,
                              message: "no_connection",
                              description: "No connection detected"
                             )
    )
    
    public static var networkError = HttpError(
        errorBody: ErrorModel(error: true,
                              status: 503,
                              message: "network_error",
                              description: "Network Error"
                             )
    )
    
    public static func == (lhs: HttpError, rhs: HttpError) -> Bool {
        return lhs.errorBody == rhs.errorBody
    }
}

extension Result {
    public var mapAsHTTPError: Result<Success, HttpError> {
        self.mapError {
            $0.asHTTPError
        }
    }
}

extension Error {
    public var asHTTPError: HttpError {
        self as? HttpError ?? HttpError.networkError
    }
}
