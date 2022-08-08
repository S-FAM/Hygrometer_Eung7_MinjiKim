//
//  Measure.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/26.
//

import UIKit

/// Device screen size aware measure unit that lets to set custom sizes for 4 predefined sizes `regular`, `medium`, `small`, and `tiny`.
///
/// - Usage
/// Use initializer ``init(regular:medium:small:tiny:)`` in order to create desired ``Measure`` and its recommended to keep it available only within context of the usage.
/// In order to increase readability, store values in its `CGFloat` value immediately  using ``forScreen`` after initialization.
///
/// - Full coverage
/// ```swift
/// extension Measure {
///   fileprivate struct ExampleContext {
///     static let adaptiveHeight: CGFloat = Measure(regular: 80, medium: 60, small: 40, tiny: 20).forScreen
///   }
/// }
/// ```
///
/// - Partial coverage
/// In case of partical coverage of dimensions, missing dimensions will use first available value higher from it.
///
/// ```swift
/// extension Measure {
///  fileprivate struct ExampleContext {
///     static let adaptiveWidth: CGFloat = Measure(regular: 80, small: 40).forScreen
///   }
/// }
/// ```
///
public struct Measure {
  // Static in order to let it measure only once lazily
  private static let isLarge: Bool = UIScreen.main.bounds.height > 800
  private static let isTiny: Bool = UIScreen.main.bounds.height < 600
  private static let isMedium: Bool = UIScreen.main.scale >= 3.0
  private static let isSmall: Bool = UIScreen.main.scale < 3.0
  
  private let regular: CGFloat
  private let medium: CGFloat
  private let small: CGFloat
  private let tiny: CGFloat
  
  /// Shows if the device screen has bottom/top cornered notch area, starting from iPhone X or later
  public static var hasNotch: Bool { return isLarge }
  
  /// Instantiates ``Measure`` with given values in points
  /// - Parameters:
  ///   - regular: for most recent devices, starting from iPhone X, which have screen height more than 800pts. All devices do not have physical Touch ID button.
  ///   - medium: iPhone Plus model devices of previous generation: iPhone 8 Plus, iPhone 7 Plus, iPhone 6s Plus, iPhone 6 Plus. Uses `regular` when omitted.
  ///   - small: old devices with dimensions of 375x667 and scale of 2x, which are: 4.7" iPhone SE, iPhone 6, iPhone 6s, iPhone 7, iPhone 8. Uses `medium` when omitted
  ///   - tiny: the most smallest screen sizes: 4" iPhone SE  and iPod touch 5th generation and later with screen height less than 600pts. Uses `small` when omitted
  public init(regular: CGFloat, medium: CGFloat? = nil, small: CGFloat? = nil, tiny: CGFloat? = nil) {
    self.regular = regular
    self.medium = medium ?? regular
    self.small = small ?? medium ?? regular
    self.tiny = tiny ?? small ?? medium ?? regular
  }
  
  /// Determines current device's dimensions and returns proper predefined value
  public var forScreen: CGFloat {
    if Measure.isLarge { return regular }
    if Measure.isTiny { return tiny }
    return Measure.isSmall ? small : medium
  }
}
