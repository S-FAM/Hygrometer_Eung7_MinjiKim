//
//  HomeViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/03.
//

import UIKit
import SnapKit
import CoreLocation

class HomeViewController: UIViewController {
  // MARK: - Properties
  let viewModel = HomeListViewModel()
  var locationManager = CLLocationManager()
  var currentLocation: Location?
  var humidity: Int?

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
    label.font = .systemFont(ofSize: 15.0, weight: .regular)

    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd.E"
    let str = formatter.string(from: now)
    label.text = str

    return label
  }()

  lazy var lastUpdateLabel: UILabel = {
    let label = UILabel()
    label.text = "최근 업데이트 : 22:16"
    label.font = .systemFont(ofSize: 15.0, weight: .regular)
    label.textColor = .white

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
  
  lazy var locationAlert: UIAlertController = {
    let alter = UIAlertController(title: "위치 권한 설정 오류", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    let noAction = UIAlertAction(title: "아니오", style: .destructive)
    alter.addAction(okAction)
    alter.addAction(noAction)
    
    return alter
  }()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    showEntryVC()
    configureUI()
    loadLocation()
    BookmarkManager.shared.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkLocationAuthorization()
  }

  // MARK: - Helpers
  private func showEntryVC() {
    let entryVC = EntryViewController()
    entryVC.modalPresentationStyle = .fullScreen
    present(entryVC, animated: false)
  }

  private func configureUI() {
    view.backgroundColor = .white
    navigationController?.isNavigationBarHidden = true

    let bookmarkStack = UIStackView(arrangedSubviews: [ bookmarkTitle, rightArrowButton ])
    bookmarkStack.axis = .horizontal
    bookmarkStack.distribution = .equalCentering

    [ backgroundView, percentageLabel, bearImage, searchButton, gearButton, currentLocationLabel, dateLabel, bookmarkStack, collectionView, lastUpdateLabel ]
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
      make.bottom.equalTo(lastUpdateLabel.snp.top).offset(-4)
    }

    lastUpdateLabel.snp.makeConstraints { make in
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

  private func loadLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func updateBackgroundColor() {
    if let humidity = humidity {
      if humidity >= 80 {
        backgroundView.backgroundColor = .veryMosit
      } else if humidity >= 60 {
        backgroundView.backgroundColor = .moist
      } else if humidity >= 40 {
        backgroundView.backgroundColor = .comfortable
      } else if humidity >= 30 {
        backgroundView.backgroundColor = .dry
      } else {
        backgroundView.backgroundColor = .veryDry
      }
    }
  }
  
  private func updateHumidity(location: Location) {
    currentLocationLabel.text = location.location
    
    let lat = CLLocationDegrees(location.lon)!
    let lon = CLLocationDegrees(location.lat)!
    let requestModel = WeatherRequestModel(lat: lat, lon: lon)
    let loadingVC = LoadingViewController()
    WeatherServiceManager().load(requestModel: requestModel) { [weak self] humidity in
      guard let self = self else { return }
      self.humidity = humidity
      self.percentageLabel.text = "\(humidity)%"
      self.lastUpdateLabel.text = self.viewModel.currentTime
      self.updateBackgroundColor()
      self.collectionView.reloadData()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        loadingVC.dismiss(animated: false)
      }
    }
    loadingVC.modalPresentationStyle = .overFullScreen
    present(loadingVC, animated: false)
  }
  
  private func checkLocationAuthorization() {
    switch locationManager.authorizationStatus {
    case .denied:
      present(self.locationAlert, animated: true)
    default:
      break
    }
  }

  // MARK: - Selectors
  @objc private func showSearchVC() {
    let searchVC = PresentViewController(sceneType: .searh)
    searchVC.delegate = self
    present(searchVC, animated: true)
  }

  @objc private func showBookmarkVC() {
    let bookmarkVC = PresentViewController(sceneType: .bookmark)
    bookmarkVC.delegate = self
    present(bookmarkVC, animated: true)
  }

  @objc private func showSettingskVC() {
    let settingsVC = SettingsViewController()
    navigationController?.pushViewController(settingsVC, animated: true)
  }

  @objc private func didTapUpdateButton() {
    locationManager.startUpdatingLocation()
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
    cell.configureUI(location: viewModel.bookmarks[indexPath.row])
    
    if let humidity = humidity {
      if humidity >= 80 {
        cell.background.backgroundColor = .veryMosit
      } else if humidity >= 60 {
        cell.background.backgroundColor = .moist
      } else if humidity >= 40 {
        cell.background.backgroundColor = .comfortable
      } else if humidity >= 30 {
        cell.background.backgroundColor = .dry
      } else {
        cell.background.backgroundColor = .veryDry
      }
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSection
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    updateHumidity(location: viewModel.bookmarks[indexPath.row])
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let geocoder = CLGeocoder()
      let locale = Locale(identifier: "Ko-KR")
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      let request = WeatherRequestModel(lat: lat, lon: lon)
      WeatherServiceManager().load(requestModel: request) { [weak self] humidity in
        guard let self = self else { return }
        let cllLocation = CLLocation(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeLocation(cllLocation, preferredLocale: locale) { placemarks, _ in
          guard let placemarks = placemarks else { return }
          guard let address = placemarks.first else { return }
          DispatchQueue.main.async {
            let administrativeArea = address.administrativeArea ?? ""
            let locality = address.locality ?? ""
            let subLocality = address.subLocality ?? ""
            let text = administrativeArea + " " + locality + " " + subLocality
            self.currentLocationLabel.text = text
          }
        }
        self.percentageLabel.text = "\(humidity)%"
        self.lastUpdateLabel.text = self.viewModel.currentTime
        self.humidity = humidity
        self.updateBackgroundColor()
        self.collectionView.reloadData()
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .denied:
      checkLocationAuthorization()
    default:
      break
    }
  }
}

extension HomeViewController: BookmarkManagerDelegate {
  func updateCollectionView() {
    collectionView.reloadData()
  }
}

extension HomeViewController: PresentViewControllerDelegate {
  func didTapLocation(location: Location) {
    updateHumidity(location: location)
  }
}
