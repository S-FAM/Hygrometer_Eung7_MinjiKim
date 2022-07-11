//
//  SettingsTableViewCell.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  static let identifier = "SettingsTableViewCell"

  private let containerView = UIView()

  private let iconImage: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .black

    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)

    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .gray

    return label
  }()

  private let image = ["paperplane.fill", "info.circle"]
  private let text = ["의견 보내기", "버전 정보"]

  func setupUI(_ row: Int) {
    selectionStyle = .none

    iconImage.image = UIImage(systemName: image[row])
    titleLabel.text = text[row]
    descriptionLabel.text = row == 1 ? "v\(getCurrentVersion())" : ""

    addSubview(containerView)

    containerView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(30)
    }

    [iconImage, titleLabel, descriptionLabel].forEach {
      containerView.addSubview($0)
    }

    iconImage.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.leading.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImage.snp.trailing).offset(10)
      make.centerY.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints { make in
      make.trailing.centerY.equalToSuperview()
    }
  }

  func getCurrentVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
    return version
  }
}
