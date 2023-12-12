//
//  Utilities.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import Foundation


import UIKit

class Utilities: NSObject {
    
    static func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    //MARK: JSON
    static func jsonToString(json: Any) -> String?{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString
        } catch let myJSONError {
            print(myJSONError)
        }
        
        return nil
    }
    
    static func objectFromJsonString(str:String) -> Any?{
        
        let jsonString = str
        let jsonData = jsonString.data(using: .utf8)
        let dict = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
        return dict
    }
    
    static func loadJsonFile(name : String) -> Any? {
        
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {

                    return jsonResult
                  }
              } catch {
                   // handle error
              }
        }
        
        return nil
    }
    
    
    //MARK:- Calling number
    class func openURL(_ strUrl : String) {
        if let url = URL(string: strUrl), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func toDouble(value : Double) -> String{
        
        //let disValue = dis.toDouble()
        let disValue = String(format: "%0.2f",value)
        if disValue != "0.0" && disValue != "0.00"{
            
            return "\(disValue)"
        }
        
        return "-"
    }
    
    //MARK: - Alert Method
    class func displayAlert(_ message: String) {
        let alert = UIAlertController(title:AppName, message: message, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "OK", style: .default) { (action) -> Void in
        }
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }

    //MARK: - topMostViewController
    class func topMostViewController() -> UIViewController {
        var topViewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController!
    }

    //MARK: - Validation Methods
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
