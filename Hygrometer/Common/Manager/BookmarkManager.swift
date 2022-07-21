//
//  BookmarkManager.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/18.
//

import Foundation

protocol BookmarkManagerDelegate: AnyObject {
  func updateCollectionView()
}

struct Location: Codable {
  let id: String
  let lat: String
  let lon: String
  let location: String
}

class BookmarkManager {
  private init() {}
  static let shared = BookmarkManager()
  weak var delegate: BookmarkManagerDelegate?
  
  var bookmarks: [Location] = [] {
    didSet {
      UserDefaultsManager.setBookmark(bookmarks: bookmarks)
      delegate?.updateCollectionView()
    }
  }
}

extension BookmarkManager {
  func insertBookmark(location: Location) {
    bookmarks.insert(location, at: 0)
  }
  
  func removeBookmark(location: Location) {
    guard let index = bookmarks.firstIndex(where: { $0.id == location.id }) else { return }
    bookmarks.remove(at: index)
  }
}
