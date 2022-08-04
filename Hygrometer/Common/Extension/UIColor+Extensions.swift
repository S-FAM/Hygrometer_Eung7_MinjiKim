//
//  UIColor+Extensions.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/09.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, asdf: Int = 0xFF) {
    self.init(
      red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: CGFloat(asdf) / 255.0
    )
  }

  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }

  convenience init(argb: Int) {
    self.init(
      red: (argb >> 16) & 0xFF,
      green: (argb >> 8) & 0xFF,
      blue: argb & 0xFF,
      asdf: (argb >> 24) & 0xFF
    )
  }
}

extension UIColor {
  static var comfortable: UIColor {
    return UIColor(rgb: 0x34ACE0)
  }

  static var veryDry: UIColor {
    return UIColor(rgb: 0xF19066)
  }

  static var dry: UIColor {
    return UIColor(rgb: 0xF5CD79)
  }

  static var moist: UIColor {
    return UIColor(rgb: 0x34ACE0)
  }

  static var veryMosit: UIColor {
    return UIColor(rgb: 0x546DE5)
  }
  
  static var buttonForegroundColor: UIColor {
    return UIColor.init(rgb: 0x4C4C4C)
  }
  
  static var buttonBackgroundColor: UIColor {
    return UIColor.init(rgb: 0xD9D9D9)
  }
}
