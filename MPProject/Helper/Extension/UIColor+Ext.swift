//
//  UIColor+Ext.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import UIKit

public extension UIColor {
    class var baseWhite: UIColor { UIColor(hex: "#FFFFFFFF")! }
    class var uktPrimary: UIColor { UIColor(hex: "#EC7000FF")! }
    class var uktSecondary: UIColor { UIColor(hex: "#FF9838FF")! }
    
    class var uktBlue_01: UIColor { UIColor(hex: "#003399FF")! }
    class var uktBlue_02: UIColor { UIColor(hex: "#4657E3FF")! }
    
    class var uktBrown_01: UIColor { UIColor(hex: "#56504CFF")! }
    class var uktBrown_02: UIColor { UIColor(hex: "#89837FFF")! }
    class var uktBrown_03: UIColor { UIColor(hex: "#B9B4AFFF")! }
    class var uktBrown_04: UIColor { UIColor(hex: "#FFF2E5FF")! }
}

extension UIColor {
    convenience init?(hex: String) {
        let rColor, gColor, bColor, aColor: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    rColor = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    gColor = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    bColor = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    aColor = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(
                        red: rColor,
                        green: gColor,
                        blue: bColor,
                        alpha: aColor
                    )

                    return
                }
            }
        }

        return nil
    }
}
