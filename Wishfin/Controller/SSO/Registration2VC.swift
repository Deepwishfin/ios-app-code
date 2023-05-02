//
//  Registration2VC.swift
//  Wishfin
//
//  Created by Wishfin on 09/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class Registration2VC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var fNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var panTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var continButton: UIButton!
    @IBOutlet weak var registerView: UIView!
    
    //MARK: Variables
    var emailString = ""
    var mobileString = ""
    var isTermAccepted = false
    let datePicker = UIDatePicker()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        registerView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        fNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        panTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        dobTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupDatePicker()
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = .date
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        components.year = -65
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dobTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if textfield.tag == 0{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                    if (text.isEmpty) {
                        floatingLabelTextField.errorMessage = AlertField.emptyfNameString
                    }
                    else if !isfNameValid(name: text){
                        floatingLabelTextField.errorMessage = AlertField.invalidfNameString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            if textfield.tag == 1{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                     if !ismNameValid(name: text){
                        floatingLabelTextField.errorMessage = AlertField.invalidmNameString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            else if textfield.tag == 2{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                     if (text.isEmpty){
                        floatingLabelTextField.errorMessage = AlertField.emptylNameString
                    }
                     else if !isfNameValid(name: text){
                        floatingLabelTextField.errorMessage = AlertField.invalidlNameString
                     }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            else if textfield.tag == 3{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                    if (text.isEmpty){
                        floatingLabelTextField.errorMessage = AlertField.emptDobString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            else if textfield.tag == 4{
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                     if !isPancardValid(pannumber: text){
                        floatingLabelTextField.errorMessage = AlertField.invalidPanString
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
    }

    //MARK: Internal Method
    @IBAction func pushToTermPage(_ sender: Any) {
        let obj = TermsnCondVC.init(nibName: TermsnCondVC.className(), bundle: nil)
        obj.isSignUp = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        if fNameTextField.text!.isEmpty{
            fNameTextField.errorMessage = AlertField.emptyfNameString
        }
        else if lNameTextField.text!.isEmpty{
            lNameTextField.errorMessage = AlertField.emptylNameString
        }
        else if dobTextField.text!.isEmpty{
            self.view.makeToast(AlertField.emptDobString, duration: 3.0, position: .center)
        }
        else if panTextField.text!.isEmpty{
            panTextField.errorMessage = AlertField.emptyPanString
        }
        else if !isPancardValid(pannumber: panTextField.text!){
            panTextField.errorMessage = AlertField.invalidPanString
        }
        else if !isTermAccepted {
            self.view.makeToast(AlertField.acceptTnC, duration: 3.0, position: .center)
        }
        else {
            let otpVC = OTPVC.init(nibName: OTPVC.className(), bundle: nil)
            otpVC.mobileString = mobileString
            otpVC.emailString = emailString
            otpVC.fName = fNameTextField.text!
            otpVC.mName = mNameTextField.text!
            otpVC.lName = lNameTextField.text!
            otpVC.dobString = dobTextField.text!
            otpVC.panString = panTextField.text!
            otpVC.isComingFromLogin = false
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    @IBAction func termBtnClicked(_ sender: UIButton) {
        if (sender.isSelected == true){
            sender.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
            sender.isSelected = false
            isTermAccepted = false
        }
        else{
            sender.setBackgroundImage(UIImage(named: "check"), for: .normal)
            sender.isSelected = true
            isTermAccepted = true
        }
    }
}

extension Registration2VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 20
        switch textField.tag {
        case 0:
            maxLength = 15
        case 1:
            maxLength = 10
        case 2:
            maxLength = 15
        case 3:
            maxLength = 20
        case 4:
            maxLength = 10
        default:
            maxLength = 20
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
