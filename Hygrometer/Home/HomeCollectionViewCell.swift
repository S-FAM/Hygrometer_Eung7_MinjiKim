//
//  HomeCollectionViewCell.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/09.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = "HomeCollectionViewCell"

  lazy var background: UIView = {
    let view = UIView()
    view.backgroundColor = .comfortable
    view.layer.cornerRadius = 23.0

    return view
  }()

  lazy var locationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 18.0, weight: .semibold)
    label.text = "경기도 수원시 장안구 파장동"

    return label
  }()

  // MARK: - Helpers
  func configureUI(location: Location) {
    contentView.backgroundColor = .white
    
    locationLabel.text = location.location

    contentView.addSubview(background)
    background.addSubview(locationLabel)

    background.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    locationLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(16)
    }
  }
}
