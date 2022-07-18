//
//  PresentViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import UIKit

class PresentViewController: UIViewController {

  private lazy var topFadeView: UIView = {
    let view = UIView()

    return view
  }()

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 40
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.masksToBounds = true

    return view
  }()

  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

    return button
  }()

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchBarStyle = .minimal
    searchBar.placeholder = "지역 검색"

    return searchBar
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Bookmark"
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textAlignment = .center

    return label
  }()
    
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(PresentTableViewCell.self, forCellReuseIdentifier: PresentTableViewCell.identifier)

    return tableView
  }()

  private var sceneType: SceneType

  init(sceneType: SceneType) {
    self.sceneType = sceneType
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    applySceneType()
    setGesture()
  }

  private func setupUI() {
    view.backgroundColor = .clear

    [topFadeView, containerView].forEach {
      view.addSubview($0)
    }

    topFadeView.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.top.leading.trailing.equalToSuperview()
    }

    containerView.snp.makeConstraints { make in
      make.top.equalTo(topFadeView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    [closeButton, searchBar, titleLabel, tableView].forEach {
      containerView.addSubview($0)
    }

    let inset: CGFloat = 8

    closeButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.top.trailing.equalToSuperview().inset(inset)
    }

    [searchBar, titleLabel].forEach {
      $0.snp.makeConstraints { make in
        make.top.equalTo(closeButton.snp.bottom)
        make.leading.trailing.equalToSuperview().inset(inset)
      }
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(inset)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func applySceneType() {
    switch sceneType {
    case .searh:
      searchBar.isHidden = false
      titleLabel.isHidden = true
    case .bookmark:
      searchBar.isHidden = true
      titleLabel.isHidden = false
    }
  }

  private func setGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
    topFadeView.addGestureRecognizer(tapGesture)
  }

  @objc func dismissSelf() {
    dismiss(animated: true)
  }
}

extension PresentViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: PresentTableViewCell.identifier
    ) as? PresentTableViewCell else { return UITableViewCell() }

    cell.setupUI()

    return cell
  }
}
