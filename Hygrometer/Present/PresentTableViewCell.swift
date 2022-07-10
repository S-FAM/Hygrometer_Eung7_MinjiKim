//
//  PresentTableViewCell.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import UIKit

class PresentTableViewCell: UITableViewCell {
  static let identifier = "PresentTableViewCell"

  private lazy var roundRectangleView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 20
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowRadius = 8.0
    view.layer.shadowOffset = CGSize(width: 0, height: 0)

    return view
  }()

  private lazy var text: UILabel = {
    let label = UILabel()
    label.text = "경기도 수원시 장안구 파장동"
    label.font = .systemFont(ofSize: 15, weight: .regular)

    return label
  }()

  private lazy var bookmarkBtn: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "star"), for: .normal)
    button.tintColor = .systemYellow

    return button
  }()

  func setupUI() {
    selectionStyle = .none

    [roundRectangleView, text, bookmarkBtn].forEach {
      addSubview($0)
    }

    roundRectangleView.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.top.bottom.equalToSuperview().inset(10)
      make.leading.trailing.equalToSuperview().inset(16)
    }

    text.snp.makeConstraints { make in
      make.leading.equalTo(roundRectangleView.snp.leading).inset(20)
      make.centerY.equalToSuperview()
    }

    bookmarkBtn.snp.makeConstraints { make in
      make.trailing.equalTo(roundRectangleView.snp.trailing).inset(8)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(50)
    }
  }
}
