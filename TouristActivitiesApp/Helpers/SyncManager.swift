//
//  SyncManager.swift
//  TouristActivitiesApp
//
//  Created by iMac on 21/11/21.
//

import Foundation
import UIKit

class SyncManager: NSObject {

    // A Singleton instance
    static let sharedInstance = SyncManager()
    
    // Initialize
    private override init() {
    }
    
    func favUnfavActivity(model: ActivityModel, sender: UIButton) {
        
        if arrFavourites.contains(model.id ?? 1) {
            let ind = arrFavourites.firstIndex(of: model.id ?? 1)
            arrFavourites.remove(at: ind ?? 0)
            sender.isSelected = false
        }else {
            arrFavourites.append(model.id ?? 1)
            sender.isSelected = true
        }
        
        defaults.set(arrFavourites, forKey: "favourite_list\(getLoggedInUser())")
    }
    
    func saveLoggedInUser(userId: Int) {
        defaults.set(userId, forKey: "logged_user")
    }
    
    func resetPreferences() {
        defaults.set(false, forKey: "isLogin")
        defaults.set(0, forKey: "logged_user")
    }
    
    func getLoggedInUser() -> Int {
        return defaults.integer(forKey: "logged_user")
    }
    
    func saveRememberedUser(email: String, password: String) {
        defaults.set(email, forKey: "saved_email")
        defaults.set(password, forKey: "saved_password")
    }
    
    func setIsLogin(islogin : Bool) {
        defaults.set(islogin, forKey: "isLogin")
    }
    
    func setRememberMe(isRememberMe : Bool) {
        defaults.set(isRememberMe, forKey: "isRememberMe")
    }
    
    func getRememberMe() -> Bool {
        return defaults.bool(forKey: "isRememberMe")
    }
    
    func shareActivity(name: String, price: String) {
        
        let textToShare = [ name, price ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = Utilities.topMostViewController().view // so that iPads won't crash
        Utilities.topMostViewController().present(activityViewController, animated: true, completion: nil)
    }
    
    func onTapContact(number:String) {
        let urlSchema = "tel:"
        let numberToCall = number
        if let numberToCallURL = URL(string: "\(urlSchema)\(numberToCall)") {
            if UIApplication.shared.canOpenURL(numberToCallURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(numberToCallURL)
                } else {
                    UIApplication.shared.openURL(numberToCallURL)
                }
            }
        }
    }
}
