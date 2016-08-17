//
//  ErrorParser.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ErrorModel {
  var details: String? = ""
  var code: Int? = 1
  var content: String? = ""
}

class ErrorParser {
  static func parseError(jsonData: JSON) -> ErrorModel? {
    guard let content = jsonData["Content"].string else {
      return nil
    }
    var error = ErrorModel()
    error.details = jsonData["Details"].string
    error.code = jsonData["Code"].int
    error.content = content
    return error
  }
}