//
//  noticeTableViewCell.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit

class noticeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var noticeTitleLabel: UILabel!
  @IBOutlet weak var noticeDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
