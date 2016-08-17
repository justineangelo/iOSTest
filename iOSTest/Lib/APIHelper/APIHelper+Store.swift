//
//  APIHelper+Store.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import UIKit

//Store Methods
extension APIHelper {
  func getStores(storeID: String = "") -> APIHelper {
    url = APIHelperConstants.Store.uri.stringByReplacingOccurrencesOfString(APIHelperConstants.ReplaceableKeys.storeID, withString: storeID)
    functionName = #function
    httpMethod = "POST"
    httpSuccessCode = 200
    return self
  }
}