//
//  APIHelperConstants.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

struct APIHelperConstants {
  struct Production {
    static let url = "https://distantlook-dev.azurewebsites.net/api/shopper/"
    static let headers = ""
  }
  
  struct Development {
    static let url = "https://distantlook-dev.azurewebsites.net/api/shopper/"
    static let headers = ""
  }
  
  struct Request {
    static let Headers = ["Accept": "application/json", "Content-Type": "application/json"]
  }
  
  struct ReplaceableKeys {
    static let storeID = "[store_id]"
  }
  
  struct Store {
    static let uri = "getstores/[store_id]"
    static let httpMethod = "POST"
    static let successCode = 200
  }
}