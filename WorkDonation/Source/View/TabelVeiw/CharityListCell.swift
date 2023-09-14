//
//  CharityListCell.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/25.
//

import UIKit

class CharityListCell: UITableViewCell {
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var statusView: UIView!
  @IBOutlet var statusLabel: UILabel!
  
  @IBOutlet var shadowView: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var percentageLabel: UILabel!
  @IBOutlet var co2Label: UILabel!
  @IBOutlet var treeLabel: UILabel!
  
  @IBOutlet var personLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  func shadow(view: UIView, radius: CGFloat?, offset: CGSize) {
      view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      view.layer.cornerRadius = radius ?? 0
      view.layer.shadowOpacity = 1
      view.layer.shadowOffset = offset
      view.layer.shadowRadius = 4
  }
  
  func initWithCharityList(_ list: CharityListV2) {
    
    shadowView.layer.masksToBounds = false
    shadow(view: shadowView, radius: 10, offset: CGSize(width: 0, height: 2))
    
    let dateFormatter = DateFormatter()
    let date = Date()
    thumbnailImageView.kf.setImage(with: URL(string: "\(list.thumbnail ?? "")" ))
    
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let today = dateFormatter.string(from: date)
    
    personLabel.text = "현재 기부인원 : \(list.count.formattedProductPrice() ?? "0")명"
    titleLabel.text = list.company
    contentLabel.text = list.title
    co2Label.text = "\(list.co2)"
    treeLabel.text = "\(list.tree)"
    dateLabel.text = "\(list.startDate) ~ \(list.endDate)"
    
    if !list.active {
      if Int(today.components(separatedBy: ".").joined())! < Int(list.startDate.components(separatedBy: ".").joined())! {
        statusLabel.text = "진행예정"
        statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else {
        statusLabel.text = "마감"
        statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      }
    } else if list.active {
      if Int(today.components(separatedBy: ".").joined())! < Int(list.startDate.components(separatedBy: ".").joined())! {
        statusLabel.text = "진행예정"
        statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else if Int(today.components(separatedBy: ".").joined())! > Int(list.endDate.components(separatedBy: ".").joined())! {
        statusLabel.text = "마감"
        statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else {
        statusLabel.text = "진행중"
        statusView.backgroundColor = #colorLiteral(red: 0.9998399615, green: 0.7317306399, blue: 0.02152590081, alpha: 1)
      }
    }
    
    percentageLabel.text = "\(Int(Double((Double(list.current) / Double(list.goal)) * 100)))%"
  }
    
}
