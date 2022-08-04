//
//  EntryViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/19.
//

import UIKit
import SnapKit
import WaterDrops

class EntryViewController: UIViewController {
  
  private lazy var bearImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "곰돌이")
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  /// - Parameters:
  ///   - Length: water drops movement range
  ///   - Duration: water drops movement speed
  private lazy var waterDrops: WaterDropsView = {
    let view = WaterDropsView(
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      direction: .up,
      dropNum: 15,
      color: UIColor.white.withAlphaComponent(0.7),
      minDropSize: Measure.Entry.waterDropsMinSize,
      maxDropSize: Measure.Entry.waterDropsMaxSize,
      minLength: 50,
      maxLength: 80,
      minDuration: 1,
      maxDuration: 3
    )
    
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .gray
    
    [waterDrops, bearImage].forEach {
      view.addSubview($0)
    }
    
    bearImage.snp.makeConstraints { make in
      let width = Measure.Entry.bearImageWidth
      let height = width * (1.1466)
      make.width.equalTo(width); make.height.equalTo(height)
      make.center.equalToSuperview()
    }
    
    waterDrops.snp.makeConstraints { make in
      make.bottom.equalTo(bearImage.snp.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(30)
      make.height.equalTo(120)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      self.waterDrops.addAnimation()
    }
  }
}

extension Measure {
  fileprivate struct Entry {
    static let bearImageWidth: CGFloat = Measure(regular: 160, medium: 145, small: 125, tiny: 105).forScreen
    static let waterDropsMinSize: CGFloat = Measure(regular: 10, medium: 10, small: 5, tiny: 5).forScreen
    static let waterDropsMaxSize: CGFloat = Measure(regular: 20, medium: 20, small: 15, tiny: 15).forScreen
  }
}
