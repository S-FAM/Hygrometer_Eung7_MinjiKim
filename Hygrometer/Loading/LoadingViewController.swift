//
//  LoadingViewController.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/26.
//

import SnapKit
import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
  // MARK: - Properties
  lazy var indicator: NVActivityIndicatorView = {
    let view = NVActivityIndicatorView(frame: .zero)
    view.type = .ballScaleMultiple
    view.color = .white
    view.startAnimating()
    
    return view
  }()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Helpers
  private func configureUI() {
    view.backgroundColor = .black
    view.layer.opacity = 0.9
    
    view.addSubview(indicator)
    
    indicator.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(50)
    }
  }
}
