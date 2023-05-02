//
//  CountryCodeCell.swift
//  Knackel
//
//  Created by Vijay Yadav   Singh on 16/04/18.
//  Copyright © 2018 Vijay Yadav   All rights reserved.
//

import UIKit

/// UITableViewCell class to show country code data
class CountryCodeCell: UITableViewCell {
    
    /// ariable for country name
    @IBOutlet weak var labelCountryName: UILabel!
    
    /// variable for country code
//    @IBOutlet weak var labelCountryCode: UILabel!
    
    /// UITableViewCell class life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// UITableViewCell class life cycle method
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
