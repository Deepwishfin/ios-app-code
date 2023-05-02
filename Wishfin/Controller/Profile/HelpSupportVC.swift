//
//  HelpSupportVC.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HelpSupportVC: UIViewController {
    
    @IBOutlet weak var helpTableView: UITableView!
    var titleArray = [String]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        titleArray = ["Credit Health / Cibil Score","App-related"]
        imageArray = ["creditHealth","appRelated"]
        setUpTableView()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.helpTableView.register(UINib.init(nibName: "HelpSupportCell", bundle: nil), forCellReuseIdentifier: "HelpSupportCell")
        self.helpTableView.tableFooterView = UIView()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UITableView Datasource
extension HelpSupportVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpSupportCell", for: indexPath) as! HelpSupportCell
        cell.setupCellUI(title: titleArray[indexPath.row], imageName: imageArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView Delegate
extension HelpSupportVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let obj = CreditHealthVC.init(nibName: "CreditHealthVC", bundle: nil)
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            let obj = AppRelatedVC.init(nibName: "AppRelatedVC", bundle: nil)
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

