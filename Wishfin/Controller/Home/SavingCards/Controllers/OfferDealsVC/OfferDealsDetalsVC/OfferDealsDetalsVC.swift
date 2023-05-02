//
//  OfferDealsDetalsVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 30/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import SDWebImage

class OfferDealsDetalsVC: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var detalsArry = [activeDealsModel]()
    var outletLat:String = ""
      var outletLng:String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        print(detalsArry[0])
        //OfferDealsDetalsCoppidCell
        //OfferDealsTeamCondtionCell
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
         
        
        
    }
    
    
       func setupTableView() {
             
     self.tblView.register(UINib.init(nibName: OfferDealsDetalsCoppidCell.className(), bundle: nil), forCellReuseIdentifier: OfferDealsDetalsCoppidCell.className())
    
        self.tblView.register(UINib.init(nibName: OfferDealsTeamCondtionCell.className(), bundle: nil), forCellReuseIdentifier: OfferDealsTeamCondtionCell.className())
           
             tblView.delegate = self
             tblView.dataSource = self
        
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 10
        
         }
 
    @IBAction func backBtnAction(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
      }
    
    
    
    @IBAction func Action_TakeOutlet(_ sender: UIButton)
    {
        
        let chkStr = self.detalsArry[0].offer_type
        if chkStr.contains("online") {
            
            let strWebURL = self.detalsArry[0].website_url
            
            guard let getUrl = strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
                
            }
            
            guard let url = URL(string: getUrl) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        } else {
            
            if (UIApplication.shared.canOpenURL(URL(string: "maps://")!)) {
                //do whatever you need to do here.
                UIApplication.shared.open(URL(string:
                                                "http://maps.apple.com/?daddr=\(self.detalsArry[0].latitude),\(self.detalsArry[0].longitude)")!, options: [:], completionHandler: nil)
            }
            else if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string:
                                                "comgooglemaps://?center=\(self.detalsArry[0].latitude),\(self.detalsArry[0].longitude)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
            } else {
                print("Can't use comgooglemaps://");
                UtilityClass.showAlertWithTitle(message: "some error occurred", onViewController: self, withButtonArray: nil, dismissHandler: nil)
            }
        }
    }
    
      
    @IBAction func Action_COPYCODE(_ sender: UIButton)
    {
        
            UIPasteboard.general.string = self.detalsArry[0].coupon_code
            
            self.showToast(message: "Code Copied", font: .systemFont(ofSize: 12.0))
        
      
    }
    
}


// MARK: - TableView

extension OfferDealsDetalsVC: UITableViewDataSource, UITableViewDelegate {
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return UITableView.automaticDimension
//
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120 * (UIScreen.main.bounds.size.width / 375)
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: OfferDealsDetalsCoppidCell.className(), for: indexPath) as! OfferDealsDetalsCoppidCell
            
            cell.selectionStyle = .none
            print("- - - - - - - - - - ",self.detalsArry[0].outlet_name)
            
            cell.nameLbl.text = self.detalsArry[0].outlet_name
            cell.offer_highlightsLbl.text = self.detalsArry[0].offer_highlights
            
            
            let url = URL(string: self.detalsArry[0].outletimage_url)
            cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "App-Default"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                // your rest code
            })
            
            let chkStr = self.detalsArry[0].offer_type
            let coupon_codeStr = self.detalsArry[0].coupon_code
            if chkStr.contains("online") && coupon_codeStr != "" {
                
                cell.online_OffreCode_Lbl.text = self.detalsArry[0].coupon_code
                
                cell.online_OffreCode_Btn.tag = indexPath.row
                cell.online_OffreCode_Btn.addTarget(self, action: #selector(Action_COPYCODE(_:)), for: .touchUpInside)
            } else {
                cell.Code_Height_Constraints.constant = 0.0
                
            }
            
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: OfferDealsTeamCondtionCell.className(), for: indexPath) as! OfferDealsTeamCondtionCell
            cell.expire_dateLbl.text = "1.This offer vaild till \(self.detalsArry[0].expire_date)"
            cell.tncLbl.text = "\(self.detalsArry[0].tnc)"
            cell.bank_nameLbl.text = self.detalsArry[0].bank_name
            cell.cc_card_nameLbl.text = self.detalsArry[0].cc_card_name
            
            
            if let url = URL(string: self.detalsArry[0].icon){
                let requestObj = URLRequest(url: url)
                cell.imgView.loadRequest(requestObj)
            }
            cell.takeMeBtn.tag = indexPath.row
            cell.takeMeBtn.addTarget(self, action: #selector(Action_TakeOutlet(_:)), for: .touchUpInside)
            
            
            let chkStr = self.detalsArry[0].offer_type
            if chkStr.contains("online") {
                cell.takeMeBtn.setTitle("REDEEM NOW", for: .normal)
            } else {
                cell.takeMeBtn.setTitle("TAKE ME TO THE OUTLET", for: .normal)
            }
            
            
            cell.selectionStyle = .none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: OfferDealsDetalsCoppidCell.className(), for: indexPath) as! OfferDealsDetalsCoppidCell
            
            cell.selectionStyle = .none
            return cell
            
        }
    }
    

}
