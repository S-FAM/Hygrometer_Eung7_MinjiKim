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
}
