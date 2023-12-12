//
//  LoginViewController.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import UIKit
import ObjectMapper


class LoginViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }
    
    
    //MARK: - Custom Methods
    func initialConfig() {
        
        viewEmail.setViewRedius(val: 10)
        viewPassword.setViewRedius(val: 10)
        viewEmail.setViewBorder(val: 1, color: .black)
        viewPassword.setViewBorder(val: 1, color: .black)
        txtEmail.setTextFieldPadding(val: 10)
        txtPassword.setTextFieldPadding(val: 10)
        btnLogin.setButtonRedius(val: 10)
        
        let isRememberMe = SyncManager.sharedInstance.getRememberMe()
        btnRemember.isSelected = isRememberMe ? true : false
        if isRememberMe {
            txtEmail.text = defaults.value(forKey: "saved_email") as? String ?? ""
            txtPassword.text = defaults.value(forKey: "saved_password") as? String ?? ""
        }
    }

    func isUserExist() -> Bool {
        
        if let users = Utilities.loadJsonFile(name: "users") as? [String : Any]{
            
            if let list = users["users"] as? [[String : Any]],!list.isEmpty {
                let arrUsers = Mapper<UserModel>().mapArray(JSONArray: list)
                if arrUsers.contains(where: {$0.email == txtEmail.text ?? "" && $0.password == txtPassword.text ?? ""}) {
                    let model = arrUsers.first(where: {$0.email == txtEmail.text ?? "" && $0.password == txtPassword.text ?? ""})
                    print("\(model?.email ?? "") : user is available")
                    SyncManager.sharedInstance.saveLoggedInUser(userId: model?.id ?? 1)
                    return true
                }else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func showActivitiesScreen() {
        let VC = ActivitiesViewController(nibName: "ActivitiesViewController", bundle: nil)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController = UINavigationController(rootViewController: VC)
        window?.makeKeyAndVisible()
    }

    
    //MARK: - @IBAction Methods
    @IBAction func btnRemember_Click(_ sender: UIButton) {
        
        let isRememberMe = SyncManager.sharedInstance.getRememberMe()
        if isRememberMe {
            SyncManager.sharedInstance.setRememberMe(isRememberMe: false)
            btnRemember.isSelected = false
        }else {
            SyncManager.sharedInstance.setRememberMe(isRememberMe: true)
            btnRemember.isSelected = true
        }
        
    }
    @IBAction func btnLogin_Click(_ sender: UIButton) {
        
        if validate() {
            if isUserExist() {
                if SyncManager.sharedInstance.getRememberMe() {
                    SyncManager.sharedInstance.saveRememberedUser(email: txtEmail.text ?? "", password: txtPassword.text ?? "")
                }else {
                    SyncManager.sharedInstance.saveRememberedUser(email: "", password: "")
                }
                SyncManager.sharedInstance.setIsLogin(islogin: true)
                showActivitiesScreen()
            }else {
                Utilities.displayAlert("Email or password are invalid")
            }
        }
    }
}

//MARK: - Extensions
extension LoginViewController {
    
   //MARK:- Validation TextFields
   func validate() -> Bool  {
       if (txtEmail.text?.isEmpty)!{
           Utilities.displayAlert("Please enter email address..")
           return false
       }else if Utilities.isValidEmail((txtEmail?.text)!) == false{
           Utilities.displayAlert("Please enter valid email address..")
            return false
        }else if (txtPassword.text?.isEmpty)!{
            Utilities.displayAlert("Please enter password..")
           return false
        }
       return true
   }
}

