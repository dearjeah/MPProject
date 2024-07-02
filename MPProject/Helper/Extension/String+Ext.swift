//
//  String+Ext.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation

extension String {
    var toDouble: Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        let number = formatter.number(from: self)
        return number as? Double
    }
    
    var toInt: Int? {
        Int(components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else { return nil }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(
                withAllowedCharacters: CharacterSet.urlQueryAllowed
            ),
            let escapedURL = URL(string: urlEscapedString) {
                return escapedURL
            }
        }
        return nil
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

