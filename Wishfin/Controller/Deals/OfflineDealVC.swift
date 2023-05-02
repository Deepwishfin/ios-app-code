//
//  OfflineDealVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OfflineDealVC: UIViewController {

  
    var outletLat:String = ""
    var outletLng:String = ""
    @IBOutlet weak var backBtn: UIButton!
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: "13.0") {
            backBtn.isHidden = true
        } else {
            backBtn.isHidden = false
            self.view.backgroundColor = .black
        }
        
         
        
        // Do any additional setup after loading the view.
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.view!.addGestureRecognizer(tap)
        }

        
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            // handling code
            self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func Action_Back(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_TakeOutlet(_ sender: Any)
    {
        
        if (UIApplication.shared.canOpenURL(URL(string: "maps://")!)) {
               //do whatever you need to do here.
            UIApplication.shared.open(URL(string:
                "http://maps.apple.com/?daddr=\(outletLat),\(outletLng)")!, options: [:], completionHandler: nil)
        }
        else if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?center=\(outletLat),\(outletLng)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://");
            UtilityClass.showAlertWithTitle(message: "some error occurred", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
    }
//
//        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
//            UIApplication.shared.open(URL(string:
//                "comgooglemaps://?center=\(outletLat),\(outletLng)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
//        } else {
//            print("Can't use comgooglemaps://");
//            UtilityClass.showAlertWithTitle(message: "some error occurred", onViewController: self, withButtonArray: nil, dismissHandler: nil)
//        }
//    }
    
    
}
