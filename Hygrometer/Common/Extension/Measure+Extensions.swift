//
//  Measure+Extensions.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/08/04.
//

import UIKit

extension Measure {
  struct Home {
    static let bearImageWidth: CGFloat = Measure(regular: 160, medium: 145, small: 125, tiny: 105).forScreen
    static let waterDropsMinSize: CGFloat = Measure(regular: 10, medium: 10, small: 5, tiny: 5).forScreen
    static let waterDropsMaxSize: CGFloat = Measure(regular: 20, medium: 20, small: 15, tiny: 15).forScreen
    static let percentageFontSize: CGFloat = Measure(regular: 80, medium: 75, small: 65, tiny: 55).forScreen
    static let dateFontSize: CGFloat = Measure(regular: 15, medium: 14, small: 13, tiny: 12).forScreen
    static let locationFontSize: CGFloat = Measure(regular: 18, medium: 18, small: 16, tiny: 15).forScreen
    static let bookmarkFontSize: CGFloat = Measure(regular: 18, medium: 18, small: 16, tiny: 15).forScreen
    static let collectionViewInset: CGFloat = Measure(regular: 12, medium: 12, small: 8, tiny: 8).forScreen
  }

  struct Entry {
    static let bearImageWidth: CGFloat = Measure(regular: 160, medium: 145, small: 125, tiny: 105).forScreen
    static let waterDropsMinSize: CGFloat = Measure(regular: 10, medium: 10, small: 5, tiny: 5).forScreen
    static let waterDropsMaxSize: CGFloat = Measure(regular: 20, medium: 20, small: 15, tiny: 15).forScreen
  }

  struct HomeCell {
    static let locationFontSize: CGFloat = Measure(regular: 18, medium: 17, small: 16, tiny: 14).forScreen
  }
}
