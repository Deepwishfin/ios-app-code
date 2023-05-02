//
//  UpdateInfoView.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/12/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class UpdateInfoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
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
        Bundle.main.loadNibNamed(UpdateInfoView.className(), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bottomView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
    }
}
