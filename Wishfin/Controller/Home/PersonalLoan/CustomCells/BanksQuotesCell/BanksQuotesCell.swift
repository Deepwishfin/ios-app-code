//
//  BanksQuotesCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 07/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class BanksQuotesCell: UITableViewCell {

    
    @IBOutlet weak var instantApporvedBtn: UIButton!
    @IBOutlet weak var instantApplyBtn: UIButton!
    
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var tenureLbl: UILabel!
    @IBOutlet weak var instPresentLbl: UILabel!
    @IBOutlet weak var instTitleLbl: UILabel!
    @IBOutlet weak var loanAmtTitleLbl: UILabel!
    @IBOutlet weak var loanAmtValLbl: UILabel!
    @IBOutlet weak var monthltTitleLbl: UILabel!
    @IBOutlet weak var monthlyPayLbl: UILabel!
    
    @IBOutlet weak var bankImg: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
