//
//  ProfileCell.swift
//  BlurView
//
//  Created by Vedvyas Rauniyar on 13/11/19.
//  Copyright © 2019 Vedvyas Rauniyar. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Setting cell UI
    ///
    /// - Parameters:
    ///   - title: name
    ///   - imageName: image
    func setupCellUI(title:String, imageName:String){
        titleLabel.text = title
        imgProfile.image = UIImage(named: imageName)
    }
    
}
