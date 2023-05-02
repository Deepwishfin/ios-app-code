//
//  HelpSupportCell.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HelpSupportCell: UITableViewCell {

    @IBOutlet weak var helpTitele: UILabel!
    @IBOutlet weak var helpImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellUI(title:String, imageName:String){
        helpTitele.text = title
        helpImage.image = UIImage(named: imageName)
    }
}
