//
//  StoreListCell.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/17.
//

import UIKit

class StoreListCell: UITableViewCell {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var telLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func initWithStoreList(_ list: StoreList) {
    if list.image == nil {
      thumbnailImageView.image = #imageLiteral(resourceName: "blankImage")
    } else {
      thumbnailImageView.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(list.image ?? "")"))
    }
    titleLabel.text = list.name
    addressLabel.text = list.address
    telLabel.text = list.tel
    distanceLabel.text = list.distance
    ratingLabel.text = "\(list.averageRate)"
    reviewCountLabel.text = "리뷰 \(list.reviews.count)개"
  }
  
}

