//
//  SearchBarView.swift
//  Knackel
//
//  Created by Vijay Yadav   Singh on 23/04/18.
//  Copyright © 2018 Vijay Yadav   All rights reserved.
//

import UIKit

protocol SearchTextFieldDelegate: class {
    func searchbarViewDidUpdateText(searchText: String, searchTextField:UITextField)
    func searchbarViewDidTappedOnCancelBtn(searchTextField: UITextField)
}

class SearchBarView: UIView {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    weak var delegate: SearchTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    private func commonInit(){
        if #available(iOS 11.0, *) {
            
        }
        else {
            self.frame.size = UIView.layoutFittingExpandedSize
            self.frame.size.height = 44
        }
        
        let xibView = Bundle.main.loadNibNamed("SearchBarView", owner: self, options: nil)?[0] as! UIView
        xibView.tag = 1003;
        self.backgroundColor = UIColor.clear
        searchTextField.backgroundColor = UIColor.clear
        self.addSubview(xibView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewWithTag(1003)?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.2)])
        
        if let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            
            // Finally, set the image color
            clearButton.tintColor = UIColor.white
        }
    }
    
    @IBAction func tappedOnCancelAction(_ sender: UIButton) {
        delegate?.searchbarViewDidTappedOnCancelBtn(searchTextField: searchTextField)
    }
    
    @IBAction  func textFieldDidChange(_ textField: UITextField) {
        delegate?.searchbarViewDidUpdateText(searchText: textField.text!, searchTextField: searchTextField)
    }
}

//MARK:- Extension:
extension SearchBarView: UITextFieldDelegate{
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //
    //        var newString : String?
    //
    //        if string.count == 0
    //        {
    //            if textField.text?.count==0
    //            {
    //                newString = textField.text
    //            }
    //            else
    //            {
    //                var newStr = textField.text! as NSString
    //                newStr = newStr.replacingCharacters(in: range, with: string) as NSString
    //                newString = newStr as String
    //            }
    //        }
    //        else
    //        {
    //            var newStr = textField.text! as NSString
    //
    //            newStr = newStr.replacingCharacters(in: range, with: string) as NSString
    //
    //            newString = newStr as String
    //        }
    //
    //
    //        delegate?.searchbarViewDidUpdateText(searchText: newString ?? "", searchTextField: searchTextField)
    //        return true
    //    }
    
    
    
    //    func textFieldShouldClear(_ textField: UITextField) -> Bool {
    //        delegate?.searchbarViewDidUpdateText(searchText: "", searchTextField: searchTextField)
    //        return true
    //    }
}
