//
//  LocationTableViewCell.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 02/04/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbl_CellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
