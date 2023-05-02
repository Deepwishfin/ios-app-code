//
//  DescriptionCell.swift
//  ExpandableCellDemo
//
//  Created by Demo on 13/03/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
   
    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCellUI(model:AnsModel) {
        titleLabel.text = model.AnswerChoiceText
    }

}
