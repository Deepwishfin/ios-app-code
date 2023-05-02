//
//  dealCollectionViewCell.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 12/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class dealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view_CellBG: UIView!
    
    @IBOutlet weak var img_Title: UIImageView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_DIstance: UILabel!
    @IBOutlet weak var lbl_offer: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupCellUIData(model:DealsModel) {
        
        view_CellBG.layer.borderWidth = 1.0
        view_CellBG.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view_CellBG.layer.cornerRadius = 8.0
        
        
        lbl_Title.text = model.outletName
        lbl_DIstance.text = model.outletDistance + "km away"
        lbl_offer.text = model.highlight
        
        img_Title.layer.borderWidth = 1.0
        img_Title.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        img_Title.layer.cornerRadius = 4.0
          
        let urlString = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let Imageurl = URL(string: urlString!)!
        img_Title.af_setImage(withURL: Imageurl)
         
    }
    
    
    func setupCellUIDataOnline (model:OnlineDealModel) {
        lbl_Title.text = model.brandName
        lbl_DIstance.text = model.outletDistance + "km away"
        lbl_offer.text = model.highlight
        
        img_Title.layer.borderWidth = 1.0
        img_Title.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        img_Title.layer.cornerRadius = 4.0
          
        let urlString = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let Imageurl = URL(string: urlString!)!
        img_Title.af_setImage(withURL: Imageurl)
         
    }
}
