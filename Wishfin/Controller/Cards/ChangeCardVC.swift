//
//  ChangeCardVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class ChangeCardVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.tableView!.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: LocationTableViewCell.className(), bundle: nil), forCellReuseIdentifier: LocationTableViewCell.className())
    }
 
    @IBAction func Action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - Tableview Methods
extension ChangeCardVC : UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isOnlineDeal == true {
//            if loadMoreBool == true {
//                return self.dealsOnlineArray.count
//            }
//            if self.dealsOnlineArray.count >= 5 {
                return 5
//            }
//            return self.dealsOnlineArray.count
//        } else {
//
//            if loadMoreBool == true {
//                return self.dealsOfflineArray.count
//            }
//            if self.dealsOfflineArray.count >= 5 {
//                return 5
//            }
//            return self.dealsOfflineArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.className(), for: indexPath) as! LocationTableViewCell
        
//        if isOnlineDeal == true {
//            let model = dealsOnlineArray[indexPath.row]
//            cell.setupCellUIDataOnline(model: model)
//        } else {
//            let model = dealsOfflineArray[indexPath.row]
//            cell.setupCellUIData(model: model)
//        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = DealDetailsVC.init(nibName: DealDetailsVC.className(), bundle: nil)
//        obj.hidesBottomBarWhenPushed = true
//        if isOnlineDeal == true {
//            obj.isOnlineDeal = true
//            let model = dealsOnlineArray[indexPath.row]
//            obj.userLatitude = str_Lat
//            obj.userLongitude = str_Lng
//            obj.brandCode = model.brandCode
//            obj.offerCode = model.offercode
//        } else {
//            obj.isOnlineDeal = false
//            let model = dealsOfflineArray[indexPath.row]
//            obj.userLatitude = str_Lat
//            obj.userLongitude = str_Lng
//            obj.brandCode = model.outletCode
//            obj.offerCode = model.offerCode
//        }
////        obj.strTemp_CardCode = str_CardCode
//        self.navigationController?.pushViewController(obj, animated: true)
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
//        if loadMoreBool == true {
//            return 0
//        }
        return 44
    }
   
}
