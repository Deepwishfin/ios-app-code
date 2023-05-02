//
//  OfferDealsCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 11/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OfferDealsCell: UITableViewCell {

    @IBOutlet weak var borderImg: UIImageView!
      @IBOutlet weak var bank_nameLbl: UILabel!
    @IBOutlet weak var offer_highlightsLbl: UILabel!
    @IBOutlet weak var expire_dateLbl: UILabel!
    @IBOutlet weak var expire_TitleLbl: UILabel!
    @IBOutlet weak var expire_Soonlbl: UILabel!
    
    
    
    var MainView = UIViewController()
      var dealsArry = [activeDealsModel]()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderImg.layer.cornerRadius = 6
        borderImg.layer.borderWidth = 1
        borderImg.layer.borderColor = UIColor.lightGray.cgColor
        borderImg.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dealsDataShow(dict:activeDealsModel,viewContr:UIViewController, indexPath: Int)
    {
        dealsArry = [dict]
        self.MainView = viewContr
        self.bank_nameLbl.text = dict.outlet_name
        self.offer_highlightsLbl.text = dict.offer_highlights
        self.expire_dateLbl.text = dict.expire_date
        
        let urlString = dict.outletimage_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
              let Imageurl = URL(string: urlString!)!
        self.borderImg.af_setImage(withURL: Imageurl)
        
         
        
    }
}
