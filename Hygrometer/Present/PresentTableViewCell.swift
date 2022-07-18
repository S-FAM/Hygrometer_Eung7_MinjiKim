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

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .regular)

    return label
  }()

  private lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.tintColor = .systemYellow
    button.addTarget(self, action: #selector(didTappedBookmarkButton), for: .touchUpInside)

    return button
  }()

  private var item: Items = Items.EMPTY
  private let userDefaultsManager = UserDefaultsManager()

  func setupItem(item: Items) {
    self.item = item
  }

  func setupUI() {
    selectionStyle = .none

    titleLabel.text = item.title

    if userDefaultsManager.getBookmark().contains(item.id) {
      bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    } else {
      bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
    }

    [roundRectangleView, titleLabel, bookmarkButton].forEach {
      addSubview($0)
    }

    roundRectangleView.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.top.bottom.equalToSuperview().inset(10)
      make.leading.trailing.equalToSuperview().inset(16)
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(roundRectangleView.snp.leading).inset(20)
      make.centerY.equalToSuperview()
    }

    bookmarkButton.snp.makeConstraints { make in
      make.trailing.equalTo(roundRectangleView.snp.trailing).inset(8)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(50)
    }
  }

  @objc func didTappedBookmarkButton() {
    let starImage = bookmarkButton.imageView?.image

    if starImage == UIImage(systemName: "star") {
      userDefaultsManager.setBookmark(id: item.id)
      bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    } else {
      userDefaultsManager.deleteBookmark(id: item.id)
      bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
  }
}
