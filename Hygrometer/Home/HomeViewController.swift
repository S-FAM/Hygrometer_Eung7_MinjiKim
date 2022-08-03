//
//  HomeViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/03.
//

import UIKit
import SnapKit
import CoreLocation
import WaterDrops

class HomeViewController: UIViewController {
  // MARK: - Properties
  private let viewModel = HomeListViewModel()
  private var locationManager = CLLocationManager()
  private var humidity: Int?

  private let entryVC = EntryViewController()

  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.cornerRadius = 30.0
    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    view.backgroundColor = .comfortable

    return view
  }()

  private lazy var headerBar: UIView = {
    let view = UIView()

    return view
  }()

  private lazy var searchButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    button.tintColor = .white
    button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 24.0), forImageIn: .normal)
    button.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
    button.addTarget(self, action: #selector(showSearchVC), for: .touchUpInside)

    return button
  }()

  private lazy var currentLocationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.text = "위치를 가져올 수 없습니다"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: Measure.Home.locationFontSize, weight: .medium)

    return label
  }()

  private lazy var gearButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
    button.tintColor = .white
    button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 24.0), forImageIn: .normal)
    button.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
    button.addTarget(self, action: #selector(showSettingskVC), for: .touchUpInside)

    return button
  }()

  private lazy var imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 15

    return stackView
  }()

  private lazy var bearImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bear")
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

  /// - Parameters:
  ///   - Length: water drops movement range
  ///   - Duration: water drops movement speed
  private lazy var waterDrops = WaterDropsView(
    frame: imageStackView.frame,
    direction: .up,
    dropNum: 5,
    color: UIColor.white.withAlphaComponent(0.7),
    minDropSize: Measure.Home.waterDropsMinSize,
    maxDropSize: Measure.Home.waterDropsMaxSize,
    minLength: 50,
    maxLength: 100,
    minDuration: 1,
    maxDuration: 5)

  private lazy var percentageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: Measure.Home.percentageFontSize, weight: .bold)

    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: Measure.Home.dateFontSize, weight: .regular)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd.E"
    let str = formatter.string(from: Date())
    label.text = str

    return label
  }()

  private lazy var lastUpdateLabel: UILabel = {
    let label = UILabel()
    label.text = " "
    label.font = .systemFont(ofSize: Measure.Home.dateFontSize, weight: .regular)
    label.textColor = .white

    return label
  }()

  private lazy var bookmarkTitle: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "Bookmark"
    label.font = .systemFont(ofSize: Measure.Home.bookmarkFontSize, weight: .regular)

    return label
  }()

  private lazy var rightArrowButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(showBookmarkVC), for: .touchUpInside)

    return button
  }()

  private lazy var collectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
    collectionView.isScrollEnabled = false
    collectionView.delegate = self
    collectionView.dataSource = self

    return collectionView
  }()

  private lazy var locationAlert: UIAlertController = {
    let alert = UIAlertController(title: "위치 권한 설정 오류", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    let noAction = UIAlertAction(title: "아니오", style: .destructive)
    alert.addAction(okAction)
    alert.addAction(noAction)

    return alert
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
    waterDrops.addAnimation()
  }

  // MARK: - Helpers
  private func showEntryVC() {
    entryVC.modalPresentationStyle = .fullScreen
    present(entryVC, animated: false)
  }

  private func configureUI() {
    view.backgroundColor = .white
    navigationController?.isNavigationBarHidden = true

    let bookmarkStack = UIStackView(arrangedSubviews: [ bookmarkTitle, rightArrowButton ])
    bookmarkStack.axis = .horizontal
    bookmarkStack.distribution = .equalCentering

    // view

    [backgroundView, bookmarkStack, collectionView].forEach {
      view.addSubview($0)
    }

    backgroundView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(UIScreen.main.bounds.height * 0.65)
    }

    bookmarkStack.snp.makeConstraints { make in
      make.top.equalTo(backgroundView.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(24)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(bookmarkStack.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }

    // backgroundView

    [headerBar, imageStackView, percentageLabel, dateLabel, lastUpdateLabel].forEach {
      backgroundView.addSubview($0)
    }

    // headerBar
    
    headerBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }

    [searchButton, currentLocationLabel, gearButton].forEach {
      headerBar.addSubview($0)
    }

    searchButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(8)
    }

    currentLocationLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    gearButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(8)
    }

    // imageStackView
    
    imageStackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    [waterDrops, bearImage].forEach {
      imageStackView.addArrangedSubview($0)
    }

    bearImage.snp.makeConstraints { make in
      let width = Measure.Home.bearImageWidth
      let height = width * (1.1466)
      make.width.equalTo(width)
      make.height.equalTo(height)
    }

    // labels

    percentageLabel.snp.makeConstraints { make in
      make.top.equalTo(imageStackView.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }

    dateLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(lastUpdateLabel.snp.top).offset(-4)
    }

    lastUpdateLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-8)
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
    [waterDrops, bearImage].forEach {
      $0.removeFromSuperview()
    }

    var dropNum: Int = 10

    if let humidity = humidity {
      if humidity >= 80 {
        backgroundView.backgroundColor = .veryMosit
        dropNum = 15
      } else if humidity >= 60 {
        backgroundView.backgroundColor = .moist
        dropNum = 10
      } else if humidity >= 40 {
        backgroundView.backgroundColor = .comfortable
        dropNum = 5
      } else if humidity >= 30 {
        dropNum = 2
      } else {
        backgroundView.backgroundColor = .veryDry
        dropNum = 1
      }

      waterDrops = WaterDropsView(
        frame: imageStackView.frame,
        direction: .up,
        dropNum: dropNum,
        color: UIColor.white.withAlphaComponent(0.7),
        minDropSize: Measure.Home.waterDropsMinSize,
        maxDropSize: Measure.Home.waterDropsMaxSize,
        minLength: 50,
        maxLength: 100,
        minDuration: 1,
        maxDuration: 5)
      
      [waterDrops, bearImage].forEach {
        imageStackView.addArrangedSubview($0)
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.waterDrops.addAnimation()
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

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        loadingVC.dismiss(animated: false)
        self.humidity = humidity
        self.percentageLabel.text = "\(humidity)%"
        self.lastUpdateLabel.text = self.viewModel.currentTime
        self.updateBackgroundColor()
        self.collectionView.reloadData()
      }
    }

    loadingVC.modalPresentationStyle = .overFullScreen
    present(loadingVC, animated: false)
  }

  private func checkLocationAuthorization() {
    switch locationManager.authorizationStatus {
    case .denied:
      present(self.locationAlert, animated: true)
    default: break
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
    guard let location = locations.first else { return }

    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "Ko-KR")
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    let request = WeatherRequestModel(lat: lat, lon: lon)

    WeatherServiceManager().load(requestModel: request) { [weak self] humidity in
      guard let self = self else { return }

      let cllLocation = CLLocation(latitude: lat, longitude: lon)
      geocoder.reverseGeocodeLocation(cllLocation, preferredLocale: locale) { placemarks, _ in
        guard let placemarks = placemarks,
              let address = placemarks.first else { return }

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
      self.entryVC.dismiss(animated: true)
      self.locationManager.stopUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .denied:
      checkLocationAuthorization()
    default: break
    }
  }
}

extension HomeViewController: BookmarkManagerDelegate {
  func updateCollectionView() {
    collectionView.reloadData()
  }
}

extension Measure {
  fileprivate struct Home {
    static let bearImageWidth: CGFloat = Measure(regular: 160, medium: 145, small: 125, tiny: 105).forScreen
    static let waterDropsMinSize: CGFloat = Measure(regular: 10, medium: 10, small: 5, tiny: 5).forScreen
    static let waterDropsMaxSize: CGFloat = Measure(regular: 20, medium: 20, small: 15, tiny: 15).forScreen
    static let percentageFontSize: CGFloat = Measure(regular: 80, medium: 75, small: 65, tiny: 55).forScreen
    static let dateFontSize: CGFloat = Measure(regular: 15, medium: 14, small: 13, tiny: 12).forScreen
    static let locationFontSize: CGFloat = Measure(regular: 18, medium: 18, small: 16, tiny: 15).forScreen
    static let bookmarkFontSize: CGFloat = Measure(regular: 18, medium: 18, small: 16, tiny: 15).forScreen
  }
}

extension HomeViewController: PresentViewControllerDelegate {
  func didTapLocation(location: Location) {
    updateHumidity(location: location)
  }
}
