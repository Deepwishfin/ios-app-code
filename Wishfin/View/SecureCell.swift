//
//  SecureCell.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit

class SecureCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var imgWebView: UIWebView!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        activeButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCellUIData(model:SecureModel){
        bankLabel.text = model.member_name
        timeLabel.text = "Opened on \(model.date_opened)"
        loadWebView(url: model.icon)
        if model.is_active == "1"{
            activeButton.setTitle("ACTIVE", for: .normal)
        }
        else {
            activeButton.setTitle("CLOSED", for: .normal)
            activeButton.backgroundColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
        }
    }
    
    func loadWebView(url:String){
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }
}

