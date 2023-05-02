//
//  SelectCardCell.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 17/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class SelectCardCell: UITableViewCell {

    
    @IBOutlet weak var webView_Cell: UIWebView!
    @IBOutlet weak var bankName_Cell: UILabel!
    @IBOutlet weak var accountNum_Cell: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCellUIData(model:CreditUtiliseModel) {
        bankName_Cell.text = model.member_name
        accountNum_Cell.text = model.account_number
        loadWebView(url: model.icon)
    }
    
    func loadWebView(url:String) {
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            webView_Cell.loadRequest(requestObj)
        }
    }
}
