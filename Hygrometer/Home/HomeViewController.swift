//
//  HomeViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/03.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    let viewModel = HomeListViewModel()

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 30.0
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        view.backgroundColor = .comfortable

        return view
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 24.0), forImageIn: .normal)
        button.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        button.addTarget(self, action: #selector(showSearchVC), for: .touchUpInside)

        return button
    }()

    lazy var gearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 24.0), forImageIn: .normal)
        button.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
      button.addTarget(self, action: #selector(showSettingskVC), for: .touchUpInside)

        return button
    }()

    lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "서울특별시 은평구 불광동"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18.0, weight: .medium)

        return label
    }()

    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 80.0, weight: .bold)
        label.text = "60%"

        return label
    }()

    lazy var bearImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")

        return imageView
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0, weight: .regular)

        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.E"
        let str = formatter.string(from: now)
        label.text = str

        return label
    }()

    lazy var bookmarkTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Bookmark"

        return label
    }()

    lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(showBookmarkVC), for: .touchUpInside)

        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        let bookmarkStack = UIStackView(arrangedSubviews: [ bookmarkTitle, rightArrowButton ])
        bookmarkStack.axis = .horizontal
        bookmarkStack.distribution = .equalCentering

        [ backgroundView, percentageLabel, bearImage, searchButton, gearButton, currentLocationLabel, dateLabel, bookmarkStack, collectionView ]
            .forEach { view.addSubview($0) }

        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.65)
        }

        searchButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        gearButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        currentLocationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(searchButton)
            make.leading.equalTo(searchButton.snp.trailing).offset(4)
            make.trailing.equalTo(gearButton.snp.leading).offset(-4)
        }

        bearImage.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width / 2.3
            let height = width * (1.1466)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backgroundView)
            make.width.equalTo(width); make.height.equalTo(height)
        }

        percentageLabel.snp.makeConstraints { make in
            make.top.equalTo(bearImage.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-8)
        }

        bookmarkStack.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(bookmarkStack.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12.0)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        return section
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let section = createSection()

        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }

    @objc func showSearchVC() {
      let searchVC = PresentViewController(sceneType: .searh)
      present(searchVC, animated: true)
    }

    @objc func showBookmarkVC() {
      let bookmarkVC = PresentViewController(sceneType: .bookmark)
      present(bookmarkVC, animated: true)
    }

  @objc func showSettingskVC() {
    let settingsVC = SettingsViewController()
    navigationController?.pushViewController(settingsVC, animated: true)
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.configureUI()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
