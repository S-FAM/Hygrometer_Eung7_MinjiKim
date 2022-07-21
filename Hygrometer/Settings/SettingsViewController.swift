//
//  SettingsViewController.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/10.
//

import MessageUI
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
    button.addTarget(self, action: #selector(popSelf), for: .touchUpInside)

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
    setGesture()
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

  private func setGesture() {
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(popSelf))
    view.addGestureRecognizer(swipeGesture)
  }

  @objc func popSelf() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITableView

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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      sendMail()
    }
  }
}

// MARK: - MFMailComposeVC

extension SettingsViewController: MFMailComposeViewControllerDelegate {
  func sendMail() {
    if MFMailComposeViewController.canSendMail() {
      let composeVC = MFMailComposeViewController()
      composeVC.mailComposeDelegate = self
      composeVC.setToRecipients(["gomseubi.help@gmail.com"])
      composeVC.setSubject("<곰습이> 문의 및 의견")
      composeVC.setMessageBody(bodyString(), isHTML: false)
      present(composeVC, animated: true)
    } else {
      failAlertVC()
    }
  }

  /// when sending mail fails
  func failAlertVC() {
    let alertVC = UIAlertController(
      title: "메일을 보낼 수 없습니다.",
      message: "App Store에서 'Mail' 앱을 복원하거나\n[설정 > Mail > 계정]을 확인하고 다시 시도해주세요.",
      preferredStyle: .alert
    )

    let close = UIAlertAction(title: "취소", style: .cancel)
    let move = UIAlertAction(title: "App Store로 이동", style: .default) { [weak self] _ in
      self?.goToMailAppStore()
    }

    [move, close].forEach { alertVC.addAction($0) }
    present(alertVC, animated: true)
  }

  func goToMailAppStore() {
    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"),
        UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }

  /// mail default contents
  func bodyString() -> String {
    return """
           이곳에 내용을 작성해주세요.


           -------------------

           Device Model : \(getDeviceIdentifier())
           Device OS    : \(UIDevice.current.systemVersion)
           App Version  : \(getCurrentVersion())

           -------------------
           """
  }

  func getCurrentVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
    return version
  }
  
  func getDeviceIdentifier() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }

  /// after sending mail
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true)
  }
}
