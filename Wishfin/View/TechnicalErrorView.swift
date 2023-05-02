//
//  TechnicalErrorView.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 05/12/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class TechnicalErrorView: UIView {
   
    @IBOutlet weak var titleTxtView: UITextView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    let htmlText = "Your request can't be processed now due to some technical error.Please try again later or visit <a href='https://www.wishfin.com/cibil-score'> wishfin.com </a> to check your CIBIL score."
 
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed(TechnicalErrorView.className(), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 10
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        okButton.layer.cornerRadius = 5
        logoutButton.layer.cornerRadius = 5
        titleTxtView.attributedText = htmlText.htmlToAttributedString
    }
}
