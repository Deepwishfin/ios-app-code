//
//  MyOffersV_C.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 10/03/21.
//  Copyright © 2021 Wishfin. All rights reserved.
//

import UIKit

class MyOffersV_C: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        // Do any additional setup after loading the view.
        
        guard let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails) else {
            return
        }
        guard let loginModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel else {
            return
        }
        nameLabel.text = "Hey \(loginModel.first_name)"
         
        self.submitButton.setCornerRadiusOfView(cornerRadiusValue: 5)
        
        if Defaults.getCardUnlock() { 
            Switcher.updateRootVC(SelIndex: 3)
        }
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    
    @IBAction func submitBtnClicked(_ sender: Any) {
          
//        let obj = SelectLocationVC.init(nibName: SelectLocationVC.className(), bundle: nil)
//        let obj = SavingCardVC.init(nibName: SavingCardVC.className(), bundle: nil)
//        obj.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(obj, animated: true)
         
        Defaults.setCardUnlock(true)
        Switcher.updateRootVC(SelIndex: 3)
    }
    

}
