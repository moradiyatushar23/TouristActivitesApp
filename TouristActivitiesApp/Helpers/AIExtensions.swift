//
//  AIExtensions.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import Foundation
import UIKit
import SDWebImage


//MARK: - hideKeyboardWhenTappedAround
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITextField
extension UITextField{
    
    //MARK: - Set Text Field Redius
    func setTextFieldRedius(val : CGFloat) {
        self.layer.cornerRadius = val
    }

    //MARK: - Set Text Field Border
    func setTextFieldBorder(val : CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = val
    }
    
    //MARK: - setTextFieldPadding
    func setTextFieldPadding(val: Float) {
        let paddingTxt = UIView(frame: CGRect.init(x: CGFloat(0), y: CGFloat(0), width: CGFloat(val), height: self.frame.size.height))
        self.leftView = paddingTxt
        self.leftViewMode = UITextField.ViewMode.always
    }
}

extension UIView{
    
    //MARK: - Set View Corner Redius
    func setViewRedius(val : CGFloat) {
        self.layer.cornerRadius = val
        self.clipsToBounds = true
    }

    //MARK: - Set View Corner Redius
    func setViewBorder(val : CGFloat , color: UIColor) {
        self.layer.borderWidth = val
        self.layer.borderColor = color.cgColor
    }

    //MARK: - Set View Background Color
    func setViewBackground(val : UIColor) {
        self.backgroundColor = val
    }
    
    //MARK: - Set View Shadow
    func setViewShadow(color : UIColor, radius: CGFloat, opicity : Float, widthVal : CGFloat, heightVal : CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: widthVal, height: heightVal)
        self.layer.shadowOpacity = opicity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

extension UIButton{
    
    //MARK: - Set buttin image
    func setButtonImage(val : String) {
        self.setImage(UIImage(named: val), for: .normal)
    }

    //MARK: - check buttin image
    func checkButtonImage(val : String) -> Bool {
        if self.image(for: .normal) == UIImage(named: val) {
            return true
        }
        return false
    }

    //MARK: - Set Button Corner Redius
    func setButtonRedius(val : CGFloat) {
        self.layer.cornerRadius = val
        self.clipsToBounds = true
    }
}

extension UIImageView {
    
    func setImage(url: String, placeHolder: String = "") {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if placeHolder != "" {
            self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: placeHolder))
        }else {
            self.sd_setImage(with: URL(string: url), placeholderImage: nil)
        }
    }
}
