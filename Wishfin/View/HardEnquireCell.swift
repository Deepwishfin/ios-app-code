//
//  HardEnquireCell.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit

class HardEnquireCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellUIData(model:InquiryModel){
        topLabel.text = model.member_name
        bottomLabel.text = "Amount: \(model.enquiry_amount)"
        dateLabel.text = model.date_of_enquiry
    }
}
