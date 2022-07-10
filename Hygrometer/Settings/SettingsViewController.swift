//
//  SettingsViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import UIKit

class SettingsViewController: UIViewController {

  private lazy var headerBar: UIView = {
    let view = UIView()

    return view
  }()

  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.tintColor = .black

    return button
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "설정"
    label.font = .systemFont(ofSize: 17, weight: .regular)

    return label
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.alwaysBounceVertical = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)

    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .white

    [headerBar, tableView].forEach {
      view.addSubview($0)
    }

    headerBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(headerBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    [backButton, titleLabel].forEach {
      headerBar.addSubview($0)
    }

    backButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(8)
    }

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: SettingsTableViewCell.identifier
    ) as? SettingsTableViewCell else { return UITableViewCell() }

    cell.setupUI(indexPath.row)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
