//
//  EntryViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/19.
//

import UIKit
import WaterDrops

class EntryViewController: UIViewController {

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 15

    return stackView
  }()

  private lazy var bearImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bear")
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

  /// - Parameters:
  ///   - Length: water drops movement range
  ///   - Duration: water drops movement speed
  private lazy var waterDrops = WaterDropsView(
    frame: stackView.frame,
    direction: .up,
    dropNum: 5,
    color: UIColor.white.withAlphaComponent(0.7),
    minDropSize: Measure.Entry.waterDropsMinSize,
    maxDropSize: Measure.Entry.waterDropsMaxSize,
    minLength: 50,
    maxLength: 100,
    minDuration: 1,
    maxDuration: 5)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  func setupUI() {
    view.backgroundColor = .gray

    view.addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    [waterDrops, bearImage].forEach {
      stackView.addArrangedSubview($0)
    }

    bearImage.snp.makeConstraints { make in
      let width = Measure.Entry.bearImageWidth
      let height = width * (1.1466)
      make.width.equalTo(width); make.height.equalTo(height)
    }

    waterDrops.addAnimation()
  }
}

extension Measure {
  fileprivate struct Entry {
    static let bearImageWidth: CGFloat = Measure(regular: 160, medium: 145, small: 125, tiny: 105).forScreen
    static let waterDropsMinSize: CGFloat = Measure(regular: 10, medium: 10, small: 5, tiny: 5).forScreen
    static let waterDropsMaxSize: CGFloat = Measure(regular: 20, medium: 20, small: 15, tiny: 15).forScreen
  }
}
