//
//  DealTableViewCell.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 11/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var img_Title: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_PerOff: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCellUIData(model:DealsModel) {
        lbl_Title.text = model.outletName
        lbl_Distance.text = model.outletDistance + "km away"
        lbl_PerOff.text = model.highlight
        
        img_Title.layer.borderWidth = 1.0
        img_Title.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        img_Title.layer.cornerRadius = 4.0
          
        let urlString = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let Imageurl = URL(string: urlString!)!
        img_Title.af_setImage(withURL: Imageurl)
         
    }
    
    
    func setupCellUIDataOnline (model:OnlineDealModel) {
        lbl_Title.text = model.brandName
       // lbl_Distance.text = model.outletDistance + "km away"
        lbl_PerOff.text = model.highlight
        
        img_Title.layer.borderWidth = 1.0
        img_Title.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        img_Title.layer.cornerRadius = 4.0
          
        let urlString = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let Imageurl = URL(string: urlString!)!
        img_Title.af_setImage(withURL: Imageurl)
         
    }
    
}
