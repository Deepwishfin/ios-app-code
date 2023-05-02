//
//  YearCell.swift
//  TestingDemo
//
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class YearCell: UITableViewCell {

    @IBOutlet weak var yrLabel: UILabel!
    @IBOutlet weak var janImageView: UIImageView!
    @IBOutlet weak var febImageView: UIImageView!
    @IBOutlet weak var marchImageView: UIImageView!
    @IBOutlet weak var aprImageView: UIImageView!
    @IBOutlet weak var mayImageView: UIImageView!
    @IBOutlet weak var juneImageView: UIImageView!
    @IBOutlet weak var julImageView: UIImageView!
    @IBOutlet weak var augImageView: UIImageView!
    @IBOutlet weak var septImageView: UIImageView!
    @IBOutlet weak var octImageView: UIImageView!
    @IBOutlet weak var novImageView: UIImageView!
    @IBOutlet weak var decImageView: UIImageView!
    
    let greenImage = UIImage(named: "yes")
    let redImage = UIImage(named: "no")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellUI(model:[PStatusModel]){
        for value in model{
            var isMissed = true
            if value.days == "0"{
                isMissed = false
            }
            switch value.month {
                
            case "1":
                janImageView.image = setImage(isMissed: isMissed)
            case "2":
                febImageView.image = setImage(isMissed: isMissed)
            case "3":
                marchImageView.image = setImage(isMissed: isMissed)
            case "4":
                aprImageView.image = setImage(isMissed: isMissed)
            case "5":
                mayImageView.image = setImage(isMissed: isMissed)
            case "6":
                juneImageView.image = setImage(isMissed: isMissed)
            case "7":
                julImageView.image = setImage(isMissed: isMissed)
            case "8":
                augImageView.image = setImage(isMissed: isMissed)
            case "9":
                septImageView.image = setImage(isMissed: isMissed)
            case "10":
                octImageView.image = setImage(isMissed: isMissed)
            case "11":
                novImageView.image = setImage(isMissed: isMissed)
            case "12":
                decImageView.image = setImage(isMissed: isMissed)
            default:
                print("")
            }
        }
    }
    
    func setImage(isMissed:Bool)-> UIImage{
        return isMissed ? redImage! : greenImage!
    }
    
}
