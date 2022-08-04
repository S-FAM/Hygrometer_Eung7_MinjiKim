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
    view.layer.cornerRadius = contentView.bounds.height / 2
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 0.5

    return view
  }()

  private lazy var locationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: Measure.HomeCell.locationFontSize, weight: .semibold)

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

extension Measure {
  fileprivate struct HomeCell {
    static let locationFontSize: CGFloat = Measure(regular: 18, medium: 17, small: 16, tiny: 14).forScreen
  }
}
