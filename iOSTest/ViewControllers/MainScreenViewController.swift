//
//  MainScreenViewController.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import UIKit
import ASToast
import Alamofire

class MainScreenViewController: UITableViewController {
  private lazy var storeLoader = UIRefreshControl()
  private var storeList = [StoreModel]()
  private var apiRequest: Request?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initialize()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    storeLoader.beginRefreshing()
    loadStores({ _ in
      self.storeLoader.endRefreshing()
    })
  }
  
  private func initialize() {
    self.title = "Store"
    
    initializePullToGetNew()
  }
  
  private func loadStores(completionHandler: (Bool -> Void)? = nil) {
    apiRequest = APIHelper.sharedInstance.getStores().setParameters(["SecurityCode": GlobalConstants.securityCode]).call { (flag, response) in
      self.apiRequest = nil
      if flag {
        self.storeList = StoreParser.parseStoreList(response.json!)
        self.tableView.reloadData()
      } else {
        //alert an error
        self.view.makeToast("Encountered an error please try again.", backgroundColor: nil)
      }
      completionHandler?(flag)
    }
  }
}

extension MainScreenViewController {
  private func initializePullToGetNew() {
    storeLoader.addTarget(self, action: #selector(refreshNewStores), forControlEvents: .ValueChanged)
    self.tableView.addSubview(storeLoader)
  }
  
  func refreshNewStores() {
    if let _  = apiRequest {
      storeLoader.endRefreshing()
    } else {
      storeList = []
      tableView.reloadData()
      loadStores({ _ in
        self.storeLoader.endRefreshing()
      })
    }
  }
}

//UITableViewDatasource
extension MainScreenViewController { 
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return storeList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(StoreTableViewCell.indentifier, forIndexPath: indexPath) as! StoreTableViewCell
    cell.storeData = storeList[indexPath.row]
    return cell
  }
}

//UITableViewDelegate
extension MainScreenViewController {
  
}