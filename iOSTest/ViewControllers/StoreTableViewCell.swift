//
//  StoreTableViewCell.swift
//  iOSTest
//
//  Created by Justine Rangel on 17/08/2016.
//  Copyright © 2016 ServiceSeeking. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

struct StoreModel {
  var imageUrl: String?
  var name: String?
  var description: String?
}

class StoreTableViewCell: UITableViewCell {
  static let indentifier = "StoreCell"
  @IBOutlet private weak var storeImageView: UIImageView!
  @IBOutlet private weak var storeNameLabel: UILabel!
  @IBOutlet private weak var storeDescriptionLabel: UILabel!
  
  var storeData: StoreModel? {
    didSet {
      updateUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func updateUI() {
    if let imageUrlStr = storeData?.imageUrl, imageURL = NSURL(string: imageUrlStr) {
      storeImageView.kf_setImageWithURL(imageURL)
    }
    storeNameLabel.text = storeData?.name
    storeDescriptionLabel.text = storeData?.description
  }
}