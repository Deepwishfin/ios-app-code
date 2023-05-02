//
//  TitleCell.swift
//  ExpandableCellDemo
//
//  Created by Demo on 13/03/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
   
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var openCloseBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
