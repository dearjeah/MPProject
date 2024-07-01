//
//  ViewState.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

public enum ViewState: Equatable {
    case loading
    case empty
    case error(error: HttpError?)
    case complete
}
