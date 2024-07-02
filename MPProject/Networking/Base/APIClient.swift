//
//  APIClient.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import RxSwift
import Alamofire

enum APIClientError: LocalizedError {
    case custom(String)
    case noConnection
    case cannotMapToObject
    case nilValue(String)
    var errorDescription: String? {
        switch self {
        case .custom(let description):
            return description
        case .noConnection:
            return "Please retry your connection"
        case .cannotMapToObject:
            return "Cannot map JSON into Decoodable Object"
        case .nilValue(let objectName):
            return "Value of object \(objectName) is null"
        }
    }
}
/**
 Use RxSwift
 **/
public final class APIClient {
    /// REQUEST API
    /// - Parameter router: router description
    /// - Parameter codable: codable description

    public static func request<T: Codable>(with router: APIConfiguration,
                                           codable: T.Type) -> Single<T> {
        self.request(with: router, codable: codable, error: ErrorModel.self)
    }

    public static func request<T: Codable, E: Codable & Equatable>(
        with router: APIConfiguration,
        codable: T.Type,
        error: E.Type) -> Single<T> {

        if !Connectivity.isConnectedToInternet() {
            return Single.error(HttpError.noConnectionError)
        }
        return Single<T>.create { observer -> Disposable in
            let manager = Session.default
            manager.session.configuration.timeoutIntervalForRequest = 60

            let request = manager.request(router)
                .validate()
                .responseData(completionHandler: { response in

                    #if DEBUG
                    if let data = response.data, let json = try? JSONSerialization.jsonObject(
                        with: data,
                        options: .mutableContainers
                    ) {
                        let jsonData = try? JSONSerialization.data(
                            withJSONObject: json,
                            options: .prettyPrinted
                        )
                        if let jsonData = jsonData {
                            print("Network: Response url \(router.path) with \(String(describing: response.response?.statusCode)) From BE \(String(decoding: jsonData, as: UTF8.self))")
                        } else {
                            print("Network: Failed url \(router.path) with \(String(describing: response.response?.statusCode))")
                        }
                    } else {
                        print("Network: No Response for url \(router.path) with \(String(describing: response.response?.statusCode))")
                    }
                    #endif
                    
                    
                    switch (response.response?.statusCode, response.data) {
                    case (.some(200..<300), .some(let data)):
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            observer(.success(decoded))
                        } catch let error {
                            observer(.error(error))
                        }
                    case (.some(401), .some(let data)):
                        do {
                            var decoded = try JSONDecoder().decode(ErrorModel.self, from: data)
                            decoded.status = 401
                            observer(.error(HttpError(errorBody: decoded)))
                        } catch {
                            observer(
                                .error(HttpError(
                                    errorBody:
                                        ErrorModel(
                                            error: true,
                                            status: 401,
                                            message: "invalid_app_id",
                                            description: "Client provided an invalid App ID"
                                        )
                                ))
                            )
                        }
                    case (.some(429), _):
                        observer(.error(HttpError(errorBody: ErrorModel(
                            error: true, status: 429,
                            message: "not_allowed",
                            description: "Client doesn’t have permission to access requested route/feature"
                        ))))
                    case (_, .some(let data)):
                        do {
                            var decoded = try JSONDecoder().decode(ErrorModel.self, from: data)
                            decoded.status = decoded.status ?? response.response?.statusCode
                            observer(.error(HttpError(errorBody: decoded)))
                        } catch {
                            observer(.error(HttpError.invalidToken))
                        }
                    default:
                        observer(.error(response.error ??
                                            HttpError.networkError))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
