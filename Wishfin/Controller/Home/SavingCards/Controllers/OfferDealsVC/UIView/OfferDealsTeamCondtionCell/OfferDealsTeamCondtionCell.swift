//
//  OfferDealsTeamCondtionCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 30/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OfferDealsTeamCondtionCell: UITableViewCell {
    @IBOutlet weak var expire_dateLbl: UILabel!
    @IBOutlet weak var tncLbl: UILabel!
    
    @IBOutlet weak var bank_nameLbl: UILabel!
    @IBOutlet weak var cc_card_nameLbl: UILabel!
    @IBOutlet weak var takeMeBtn: UIButton!
    @IBOutlet weak var imgView: UIWebView!
    @IBOutlet weak var bankView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bankView.layer.cornerRadius = 6
        self.bankView.layer.borderWidth = 1
        self.bankView.layer.borderColor = UIColor.lightGray.cgColor
        self.bankView.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
