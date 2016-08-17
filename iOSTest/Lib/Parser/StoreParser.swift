//
//  StoreParser.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import SwiftyJSON

class StoreParser {
  static func parseStoreList(jsonData: JSON) -> [StoreModel] {
    var storeList = [StoreModel]()
    if let storeArray = jsonData.array {
      for store in storeArray {
        if let store = StoreParser.parseStore(store) {
          storeList.append(store)
        }
      }
    }
    return storeList
  }
  
  private static func parseStore(jsonData: JSON) -> StoreModel? {
    guard let type = jsonData["Type"].int where type == 0 else {
      return nil
    }
    var store = StoreModel()
    store.name = jsonData["Metadata"]["Name"].string
    store.description = jsonData["Metadata"]["Description"].string
    return store
  }
}