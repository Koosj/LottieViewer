//
//  SupportDeveloperTableViewCell.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/07.
//

import UIKit
import StoreKit
import AppTrackingTransparency

class SupportDeveloperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roundedBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedBackgroundView.layer.cornerRadius = 10
        roundedBackgroundView.layer.borderWidth = 1.0
        roundedBackgroundView.layer.borderColor = UIColor.AccentColor?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with supportDeveloperModel: SupportDeveloperModel) {
        if let product = supportDeveloperModel.product {
            titleLabel.text = product.localizedTitle
            priceLabel.text = "\(product.price)"
        } else {
            
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                titleLabel.text = "Are you an angel?👼🏻"
                priceLabel.text = "You already allowed tracking✅"
            } else {
                titleLabel.text = "Allow tracking"
                priceLabel.text = "for banner Ads"
            }
        }
    }
}
