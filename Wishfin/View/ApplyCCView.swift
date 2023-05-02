//
//  ApplyCCView.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/12/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class ApplyCCView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var getCCButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var bottmView: UIView!
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
        Bundle.main.loadNibNamed(ApplyCCView.className(), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bottmView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
    }
}
