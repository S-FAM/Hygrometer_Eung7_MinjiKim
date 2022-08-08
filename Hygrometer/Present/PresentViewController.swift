//
//  PresentViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import UIKit
import SwiftUI

protocol PresentViewControllerDelegate: AnyObject {
  func didTapLocation(location: Location)
}

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

  private lazy var headerBar: UIView = {
    let view = UIView()

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
    searchBar.delegate = self

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
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.keyboardDismissMode = .onDrag

    tableView.dataSource = self
    tableView.delegate = self
    tableView.dragDelegate = self
    tableView.dropDelegate = self

    tableView.register(PresentTableViewCell.self, forCellReuseIdentifier: PresentTableViewCell.identifier)

    return tableView
  }()

  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .gray
    label.font = .systemFont(ofSize: 16, weight: .regular)

    return label
  }()

  private var sceneType: SceneType

  private let bookmarkManager = BookmarkManager.shared
  weak var delegate: PresentViewControllerDelegate?

  private var regionList: [Location] = []

  private var keyword = ""
  private var currentPage: Int = 1
  private let display: Int = 10

  private let inset: CGFloat = 8

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

    [headerBar, searchBar, emptyLabel, tableView].forEach {
      containerView.addSubview($0)
    }

    headerBar.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(inset)
      make.height.equalTo(50)
    }

    [closeButton, titleLabel].forEach {
      headerBar.addSubview($0)
    }

    closeButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.top.trailing.equalToSuperview().inset(inset)
      make.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    searchBar.snp.makeConstraints { make in
      make.top.equalTo(headerBar.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(inset)
    }

    emptyLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview().offset(20)
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(inset)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func applySceneType() {
    switch sceneType {
    case .search:
      searchBar.becomeFirstResponder()
      tableView.dragInteractionEnabled = false
      titleLabel.isHidden = true
      emptyLabel.text = "검색 결과가 없습니다."

    case .bookmark:
      tableView.dragInteractionEnabled = true
      searchBar.isHidden = true
      emptyLabel.text = "북마크한 지역이 없습니다."
      isHiddenEmptyLabel(dataCount: bookmarkManager.bookmarks.count)

      headerBar.snp.remakeConstraints { make in
        make.top.leading.trailing.equalToSuperview().inset(inset)
        make.height.equalTo(100)
      }

      tableView.snp.remakeConstraints { make in
        make.top.equalTo(headerBar.snp.bottom).offset(inset)
        make.leading.trailing.bottom.equalToSuperview()
      }
    }
  }

  private func setGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
    topFadeView.addGestureRecognizer(tapGesture)
  }

  /// Search for a region.
  private func requestRegionList(isReset: Bool) {
    if isReset {
      regionList = []
      currentPage = 1
    }

    AddressSearchManager().request(
      from: keyword,
      startPage: currentPage
    ) { [weak self] locations in
      guard let self = self else { return }
      self.regionList += locations
      self.currentPage += 1
      self.tableView.reloadData()
      self.isHiddenEmptyLabel(dataCount: locations.count)
    }
  }

  private func isHiddenEmptyLabel(dataCount: Int) {
    if dataCount == 0 {
      emptyLabel.isHidden = false
    } else {
      emptyLabel.isHidden = true
    }
  }

  @objc func dismissSelf() {
    dismiss(animated: true)
  }
}

// MARK: - UITabaleView

extension PresentViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sceneType == .search ? regionList.count : bookmarkManager.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: PresentTableViewCell.identifier
    ) as? PresentTableViewCell else { return UITableViewCell() }

    if sceneType == .search {
      cell.sceneType = .search
      cell.setupLocation(location: regionList[indexPath.row])
    } else {
      cell.sceneType = .bookmark
      cell.setupLocation(location: bookmarkManager.bookmarks[indexPath.row])
    }

    cell.setupUI()
    cell.onChangedBookmarks = { [weak self] in
      guard let self = self else { return }
      tableView.reloadData()
      self.isHiddenEmptyLabel(dataCount: self.bookmarkManager.bookmarks.count)
    }

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let currentRow = indexPath.row
    guard (currentRow % display) == (display - 2) && (currentRow / display) == (currentPage - 2) else { return }

    requestRegionList(isReset: false)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = indexPath.row
    let location = sceneType == .search ? regionList[row] : bookmarkManager.bookmarks[row]
    dismiss(animated: true) { [weak self] in
      self?.delegate?.didTapLocation(location: location)
    }
  }

  /// Required for sorting bookmarks.
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    var bookmarks = bookmarkManager.bookmarks
    let location = bookmarks[sourceIndexPath.row]

    bookmarks.remove(at: sourceIndexPath.row)
    bookmarks.insert(location, at: destinationIndexPath.row)

    BookmarkManager.shared.removeBookmark(index: sourceIndexPath.row)
    BookmarkManager.shared.insertBookmark(location: location, index: destinationIndexPath.row)
  }
}

// MARK: - UITableView Drag & Drop

extension PresentViewController: UITableViewDragDelegate, UITableViewDropDelegate {
  /// Required for draging rows.
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    return [UIDragItem(itemProvider: NSItemProvider())]
  }

  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    if session.localDragSession != nil {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
  }

  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}

// MARK: - UISearchBar

extension PresentViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()

    guard let searchText = searchBar.text else { return }

    keyword = searchText
    requestRegionList(isReset: true)
  }
}
