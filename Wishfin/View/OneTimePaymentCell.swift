//
//  OneTimePaymentCell.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit

class OneTimePaymentCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var imgWebView: UIWebView!
    @IBOutlet weak var missedLabel: UILabel!
    @IBOutlet weak var loanLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellUIData(model:OnTimePaymentModel){
        bankLabel.text = model.name
        loanLabel.text = model.member_name
        missedLabel.text = "\(model.missed_payment_count) Missed"
        loadWebView(url: model.icon)
    }
    
    func loadWebView(url:String){
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }
}
