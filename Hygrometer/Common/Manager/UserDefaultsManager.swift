//
//  UserDefaultsManager.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/17.
//

import Foundation

class UserDefaultsManager {
  enum Key: String {
    case bookmark
  }

  static func getBookmark() -> [Location] {
    guard let data = UserDefaults.standard.data(forKey: Key.bookmark.rawValue) else { return [] }
    return (try? PropertyListDecoder().decode([Location].self, from: data)) ?? []
  }

  static func setBookmark(bookmarks: [Location]) {
    UserDefaults.standard.setValue(try? PropertyListEncoder().encode(bookmarks), forKey: Key.bookmark.rawValue)
  }

//  func deleteBookmark(id: String) {
//    var currentBookmark: [String] = getBookmark()
//    currentBookmark.indices.filter { currentBookmark[$0] == id }.forEach {
//      currentBookmark.remove(at: $0)
//    }
//    UserDefaults.standard.setValue(try? PropertyListEncoder().encode(currentBookmark), forKey: Key.bookmark.rawValue)
//  }
}
