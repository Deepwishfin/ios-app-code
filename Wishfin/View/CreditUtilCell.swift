//
//  CreditUtilCell.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit

class CreditUtilCell: UITableViewCell {
   
    //MARK:- IBOutlets
    @IBOutlet weak var imgWebView: UIWebView!
    @IBOutlet weak var utilizeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //In card/creditutilization/card detail page we need to use credit_limit instead of sanctioned_amount and  current_balance instead of paid_amount.

    func setupCellUIData(model:CreditUtiliseModel){
        bankLabel.text = model.member_name
        if let current = Int(model.current_balance),let credLimit = Int(model.credit_limit){
            balanceLabel.text = "Used: \(current.withCommas()) / \(credLimit.withCommas())"
        }
        utilizeLabel.text = "\(model.credit_utilize)%"
        loadWebView(url: model.icon)
    }
    
    func loadWebView(url:String){
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }
}


