//
//  EntryViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/19.
//

import UIKit
import WaterDrops

class EntryViewController: UIViewController {

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
    frame: CGRect(
      x: view.frame.minX + 175,
      y: view.frame.minY + 185,
      width: 20,
      height: 100
    ),
    direction: .up,
    dropNum: 3,
    color: UIColor.white.withAlphaComponent(0.7),
    minDropSize: 10,
    maxDropSize: 20,
    minLength: 50,
    maxLength: 100,
    minDuration: 1,
    maxDuration: 5)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupAnimation()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.dismiss(animated: true)
    }
  }

  func setupUI() {
    view.backgroundColor = .gray

    [bearImage, waterDrops].forEach {
      view.addSubview($0)
    }

    bearImage.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(190)
      make.height.equalTo(219)
    }
  }

  func setupAnimation() {
    waterDrops.addAnimation()
  }
}
