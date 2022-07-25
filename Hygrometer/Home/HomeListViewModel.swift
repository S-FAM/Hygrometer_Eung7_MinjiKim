//
//  HomeListViewModel.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/09.
//

import Foundation
import CoreLocation

class HomeListViewModel {
  var bookmarks: [Location] {
    BookmarkManager.shared.bookmarks
  }
  
  var numberOfItemsInSection: Int {
    return bookmarks.count
  }
  
  var currentTime: String {
    let formatter = DateFormatter()
    let currentTime = Date()
    formatter.dateFormat = "최근 업데이트 : HH:mm"
    return formatter.string(from: currentTime)
  }
}
