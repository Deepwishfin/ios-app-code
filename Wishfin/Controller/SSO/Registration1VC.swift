//
//  Registration1VC.swift
//  Wishfin
//
//  Created by Wishfin on 09/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class Registration1VC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var continButton: UIButton!
    @IBOutlet weak var registerView: UIView!
    
    //MARK: Variable
    var mobileNumber = ""

    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        registerView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        mobileTextField.text = mobileNumber
        mobileTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if text.isEmpty{
                return
            }
            if textfield.tag == 0{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                    if !isMobileNumberValid(mobileNumberData: text) {
                        floatingLabelTextField.errorMessage = AlertField.validMobileString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            else{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                    if !isValidEmail(emailStr: emailTextField.text!){
                        floatingLabelTextField.errorMessage = AlertField.invalidEmailString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        if mobileTextField.text!.isEmpty{
            mobileTextField.errorMessage = AlertField.digitMobileString
        }
        else if !isMobileNumberValid(mobileNumberData: mobileTextField.text!) {
            mobileTextField.errorMessage = AlertField.validMobileString
        }
        else if emailTextField.text!.isEmpty{
            emailTextField.errorMessage = AlertField.emptyEmailString
        }
        else if !isValidEmail(emailStr: emailTextField.text!){
            emailTextField.errorMessage = AlertField.invalidEmailString
        }
        else {
            let reg2VC = Registration2VC.init(nibName: Registration2VC.className(), bundle: nil)
            reg2VC.mobileString = self.mobileTextField.text!
            reg2VC.emailString = self.emailTextField.text!
            self.navigationController?.pushViewController(reg2VC, animated: true)
        }
    }
    
}

extension Registration1VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else{
            return true
        }
        
    }
}
