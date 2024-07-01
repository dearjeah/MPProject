//
//  UIDate+Ext.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

extension Date {
    func toLocalTime() -> Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
