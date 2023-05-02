//
//  OnlineDealVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OnlineDealVC: UIViewController {

    @IBOutlet weak var txtField_Code: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!

    var strOfferCode:String = ""
    var strWebURL:String = ""
     
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
        txtField_Code.text = strOfferCode
      //  self.backGroundImg?.image = imagesSet
        
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
    
    @IBAction func Action_CopyBtn(_ sender: Any) {
        UIPasteboard.general.string = strOfferCode
        
        self.showToast(message: "Code Copied", font: .systemFont(ofSize: 12.0))
    }
    
    @IBAction func Action_GoToWeb(_ sender: Any) {
       
        guard let getUrl = strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: getUrl) else {
                    return
                }
               
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
