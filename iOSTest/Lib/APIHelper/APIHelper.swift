//
//  APIHelper.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ASToast

struct APIResponse {
  var json: JSON? = nil
  var statusCode: Int? = 404
  var description: String? = ""
}

typealias CompletionHandler = (Bool, APIResponse) -> Void

class APIHelper: NSObject {
  static let sharedInstance = APIHelper()
  var url : String?
  var headers : [String: String]?
  private var parameters : [String: AnyObject]?
  var httpMethod : String
  var httpSuccessCode : Int
  var functionName: String
  
  private override init() {
    httpMethod = "GET"
    httpSuccessCode = 200
    functionName = ""
    super.init()
  }
  
  private func resetParams() {
    url = ""
    headers = nil
    parameters = [:]
    httpMethod = "GET"
  }
  
  func setParameters(parameters: [String: AnyObject]) -> APIHelper {
    print("\(functionName) SETTING REQUEST PARAMETERS")
    self.parameters = parameters
    return self
  }
  
  func call(completionHandler: CompletionHandler) -> Request {
    var request: Request!
    if !Common.isConnectedToNetwork() {
      UIApplication.sharedApplication().keyWindow?.rootViewController?.view.makeToast("Please check your connetion!", backgroundColor: nil)
      request = requestStart({ (flag, response) in
        completionHandler(flag, response)
      })
    } else {
      request = requestStart({ (flag, response) in
        if !flag {
          if let error = ErrorParser.parseError(response.json!), content = error.content {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.view.makeToast(content, backgroundColor: nil)
          } else {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.view.makeToast("Error Occured!", backgroundColor: nil)
          }
        }
        completionHandler(flag, response)
      })
    }
    return request
  }
  
  private func requestStart(completionHandler: CompletionHandler) -> Request {
    var finalURL = ""
    if GlobalConstants.devEnvironment {
      finalURL += APIHelperConstants.Development.url
    } else {
      finalURL += APIHelperConstants.Production.url
    }
    finalURL += self.url ?? ""
    if httpMethod == "GET", let paramsOut = parameters {
      var queryStr = paramsOut.count > 0 ? "?" : ""
      var bool = false
      for (key, value) in paramsOut {
        if bool {
          queryStr += "&"
        }
        bool = true
        queryStr += "\(key)=\(value)"
      }
      finalURL += queryStr
    }
    let url = NSURL(string: finalURL)
    print("URL REQUEST: \(finalURL)")
    let request = NSMutableURLRequest(URL: url!)
    if httpMethod != "GET" {//Request is not get but has parameters
      if let paramsOut = parameters {
        do {
          let jsonData = try NSJSONSerialization.dataWithJSONObject(paramsOut, options: [])
          let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
          request.HTTPBody = jsonData
          print("\(functionName) API REQUEST PARAMS :")
          print(jsonString)
        } catch {
          print("\(functionName) API REQUEST PARAMS Fetch failed:")
        }
      } else {
        print("\(functionName) API REQUEST PARAMS : No Parameters")
      }
    }
    for (key, value) in APIHelperConstants.Request.Headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
    request.HTTPMethod = httpMethod
    let alamofire = Alamofire.request(request)
    alamofire.functionName = functionName
    alamofire.httpSuccessCode = httpSuccessCode
    resetParams()
    alamofire.responseData { (response) in
      var dataStr : JSON
      if let resData = response.data {
        dataStr = JSON(data: resData)
      } else {
        dataStr = JSON.init(stringLiteral: "")
      }
      let apiResponse = APIResponse(json: dataStr, statusCode: response.response?.statusCode, description: GlobalConstants.devEnvironment ? "Development" : "Production" )
      if response.response?.statusCode == alamofire.httpSuccessCode {
        print("\(alamofire.functionName) Success Handler Called")
        completionHandler(true, apiResponse)
      } else {
        print("============================================================>")
        print("RESPONSE HTTP DESC:")
        print(response.response?.description ?? "")
        print("<============================================================")
        print("\(alamofire.functionName) Failure Handler Called")
        print(apiResponse.json!)
        completionHandler(false, apiResponse)
      }
    }
    return alamofire
  }
}



import ObjectiveC
private var requestFuncNameAssociatedKey: UInt8 = 0
private var requestHTTPSuccessCodeAssociatedKey: UInt8 = 1
private var requestRemoveKeyAssociatedKey: UInt8 = 2

// MARK: - Request extension adding variables funcName and httpSucCode
extension Request {
  //Function name for the request
  var functionName: String! {
    get {
      return objc_getAssociatedObject(self, &requestFuncNameAssociatedKey) as? String
    }
    set(newValue) {
      objc_setAssociatedObject(self, &requestFuncNameAssociatedKey, newValue as String, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  //Expected success code
  var httpSuccessCode: Int {
    get {
      return objc_getAssociatedObject(self, &requestHTTPSuccessCodeAssociatedKey) as! Int
    }
    set(newValue) {
      objc_setAssociatedObject(self, &requestHTTPSuccessCodeAssociatedKey, newValue as Int, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}