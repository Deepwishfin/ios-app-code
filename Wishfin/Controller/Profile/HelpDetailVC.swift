//
//  HelpDetailVC.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HelpDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    var detailString = ""
    var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        titleLabel.text = titleString
        detailTextView.text = detailString
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
