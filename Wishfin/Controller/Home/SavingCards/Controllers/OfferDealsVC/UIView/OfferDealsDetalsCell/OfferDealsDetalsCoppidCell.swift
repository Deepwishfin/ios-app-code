//
//  OfferDealsDetalsCoppidCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 30/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OfferDealsDetalsCoppidCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var offer_highlightsLbl: UILabel!
    
    @IBOutlet weak var Code_View: UIView!
    @IBOutlet weak var online_OffreCode_Lbl: UILabel!
    @IBOutlet weak var online_OffreCode_Btn: UIButton!
    
    @IBOutlet weak var Code_Height_Constraints: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
