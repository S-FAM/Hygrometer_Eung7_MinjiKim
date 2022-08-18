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
    view.layer.cornerRadius = 30.0
    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    view.backgroundColor = .comfortable
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 0.5
    
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
  
  private lazy var bearImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bear")
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()
  
  private lazy var toCurrnetLocationButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.image = UIImage(systemName: "location.fill")
    config.imagePadding = 4
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration.init(pointSize: 12)
    config.baseForegroundColor = .buttonForegroundColor
    config.baseBackgroundColor = .buttonBackgroundColor
    config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
    config.cornerStyle = .capsule
    var container = AttributeContainer()
    container.font = .systemFont(ofSize: Measure.Home.dateFontSize, weight: .regular)
    container.foregroundColor = UIColor.buttonForegroundColor
    config.attributedTitle = AttributedString("현위치로", attributes: container)
    let button = UIButton(configuration: config)
    button.addTarget(self, action: #selector(didTapToCurrentLocationButton), for: .touchUpInside)
    
    return button
  }()

  /// - Parameters:
  ///   - Length: water drops movement range
  ///   - Duration: water drops movement speed
  private lazy var waterDrops: WaterDropsView  = {
    let drops = WaterDropsView(
      frame: CGRect(x: 0, y: 0, width: 0, height: 0),
      direction: .up,
      dropNum: 50,
      color: UIColor.white.withAlphaComponent(0.7),
      minDropSize: Measure.Home.waterDropsMinSize,
      maxDropSize: Measure.Home.waterDropsMaxSize,
      minLength: 50,
      maxLength: 80,
      minDuration: 1,
      maxDuration: 3
    )
    
    return drops
  }()
  lazy var percentageLabel: UILabel = {
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
  
  private lazy var emptyBookmarkLabel: UILabel = {
    let label = UILabel()
    label.text = "북마크된 지역이 없습니다."
    label.textAlignment = .center
    label.font = .systemFont(ofSize: Measure.Home.dateFontSize, weight: .medium)

    return label
  }()

  lazy var collectionView: UICollectionView = {
    let layout = HomeUtilities().createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
    collectionView.isScrollEnabled = false
    collectionView.delegate = self
    collectionView.dataSource = self

    return collectionView
  }()

  private lazy var locationAlert: UIAlertController = {
    let alert = UIAlertController(title: "위치 권한이 거부되었습니다.", message: "허용하러 가시겠습니까? 권한을 거부하셨더라도 지역을 검색하여 앱을 계속 이용하실 수 있습니다.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "네", style: .default) { _ in
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
    isHiddenCollectionView()
    BookmarkManager.shared.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkLocationAuthorization()
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

    [backgroundView, bookmarkStack, emptyBookmarkLabel, collectionView].forEach {
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

    emptyBookmarkLabel.snp.makeConstraints { make in
      make.centerX.equalTo(collectionView)
      make.centerY.equalTo(collectionView).offset(-20)
    }

    // backgroundView

    [headerBar, percentageLabel, dateLabel, lastUpdateLabel, toCurrnetLocationButton, waterDrops, bearImage ].forEach {
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
    
    bearImage.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      let width = Measure.Home.bearImageWidth
      let height = width * (1.1466)
      make.width.equalTo(width)
      make.height.equalTo(height)
    }
    
    waterDrops.snp.makeConstraints { make in
      make.bottom.equalTo(bearImage.snp.top).offset(-8)
      make.top.equalTo(headerBar.snp.bottom)
      make.width.equalTo(30)
      make.centerX.equalTo(bearImage)
    }

    // labels

    percentageLabel.snp.makeConstraints { make in
      make.top.equalTo(bearImage.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }
    
    toCurrnetLocationButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-8)
      make.centerX.equalToSuperview()
    }

    dateLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(lastUpdateLabel.snp.top)
    }

    lastUpdateLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(toCurrnetLocationButton.snp.top).offset(-4)
    }
  }

  private func loadLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func updateBackgroundColor() {
    var dropNum: Int = 10
    if let humidity = humidity {
      if humidity >= 80 {
        backgroundView.backgroundColor = .veryMosit
        dropNum = 20
      } else if humidity >= 60 {
        backgroundView.backgroundColor = .moist
        dropNum = 10
      } else if humidity >= 40 {
        backgroundView.backgroundColor = .comfortable
        dropNum = 5
      } else if humidity >= 30 {
        backgroundView.backgroundColor = .dry
        dropNum = 2
      } else {
        backgroundView.backgroundColor = .veryDry
        dropNum = 1
      }
    }
    waterDrops.dropNum = dropNum
    waterDrops.updateAnimation()
  }

  private func updateHumidity(location: Location) {
    let lat = CLLocationDegrees(location.lon)!
    let lon = CLLocationDegrees(location.lat)!
    let requestModel = WeatherRequestModel(lat: lat, lon: lon)
    let loadingVC = LoadingViewController()

    WeatherServiceManager().load(requestModel: requestModel) { [weak self] humidity in
      guard let self = self else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        loadingVC.dismiss(animated: false)
        self.currentLocationLabel.text = location.location
        self.humidity = humidity
        self.updateBackgroundColor()
        self.percentageLabel.text = "\(humidity)%"
        self.lastUpdateLabel.text = self.viewModel.currentTime
        self.collectionView.reloadData()
        self.locationManager.stopUpdatingLocation()
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

  private func isHiddenCollectionView() {
    if viewModel.numberOfItemsInSection == 0 {
      collectionView.isHidden = true
    } else {
      collectionView.isHidden = false
    }
  }
  
  // MARK: - Selectors
  @objc private func showSearchVC() {
    let searchVC = PresentViewController(sceneType: .search)
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
  
  @objc private func didTapToCurrentLocationButton() {
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
    self.locationManager.stopUpdatingLocation()
    if let location = locations.first {
      let geocoder = CLGeocoder()
      let locale = Locale(identifier: "Ko-KR")
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      let request = WeatherRequestModel(lat: lat, lon: lon)
      let loadingVC = LoadingViewController()
      loadingVC.modalPresentationStyle = .overFullScreen
      present(loadingVC, animated: false)
      WeatherServiceManager().load(requestModel: request) { [weak self] humidity in
        guard let self = self else { return }
        self.humidity = humidity
        let cllLocation = CLLocation(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeLocation(cllLocation, preferredLocale: locale) { placemarks, _ in
          guard let placemarks = placemarks else { return }
          guard let address = placemarks.first else { return }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loadingVC.dismiss(animated: false)
            self.percentageLabel.text = "\(humidity)%"
            self.lastUpdateLabel.text = self.viewModel.currentTime
            self.humidity = humidity
            self.updateBackgroundColor()
            self.waterDrops.addAnimation()
            self.collectionView.reloadData()
            let administrativeArea = address.administrativeArea ?? ""
            let locality = address.locality ?? ""
            let subLocality = address.subLocality ?? ""
            let text = administrativeArea + " " + locality + " " + subLocality
            self.currentLocationLabel.text = text
            self.locationManager.stopUpdatingLocation()
          }
        }
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
    default: break
    }
  }
}

extension HomeViewController: BookmarkManagerDelegate {
  func updateCollectionView() {
    collectionView.reloadData()
    isHiddenCollectionView()
  }
}

extension HomeViewController: PresentViewControllerDelegate {
  func didTapLocation(location: Location) {
    updateHumidity(location: location)
  }
}
