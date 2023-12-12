//
//  ActivitiesViewController.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import UIKit
import DropDown
import ObjectMapper

class ActivitiesViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var viewCityDropDown: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    var cityDropdown = DropDown()
    var arrCities : [String] = ["Toronto","Ontario","Alberta"]
    var arrActivity : [ActivityModel] = [ActivityModel]()
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        addNavigationBarButtons()
        setData()
    }
    
    //MARK: - Custom Methods
    func initialConfig() {
        
        title = titleActivity
        navigationController?.navigationBar.tintColor = UIColor.black
        viewCityDropDown.setViewRedius(val: 10)
        viewCityDropDown.setViewBorder(val: 0.5, color: .black)
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
    }
    
    func addNavigationBarButtons() {
        
        let favButton = UIBarButtonItem(image: UIImage(named: "unlikedall"),  style: .plain, target: self, action: #selector(showFavouriteScreen))
        navigationItem.leftBarButtonItems = [favButton]
        
        let logoutButton = UIBarButtonItem(image: UIImage(named: "ic_logout"),  style: .plain, target: self, action: #selector(onLogout))
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    func setupDropdown() {

        cityDropdown = configureDropDown(container: viewCityDropDown, arrValues: arrCities)
        cityDropdown.selectionAction = { (index: Int, item: String) in
            self.cityDropdown.hide()
            self.lblCity.text = item
            
            self.arrActivity.removeAll()
            let list = arrAllActivity.filter({$0["city"] as? String ?? "" == item})
            self.arrActivity = Mapper<ActivityModel>().mapArray(JSONArray: list)
            self.tableView.reloadData()
        }
        cityDropdown.cancelAction = {
        }
    }
    
    func setData() {
        
        arrFavourites.removeAll()
        if let arr = defaults.object(forKey: "favourite_list\(SyncManager.sharedInstance.getLoggedInUser())") {
            arrFavourites = arr as? [Int] ?? []
        }
        arrActivity.removeAll()
        let list = arrAllActivity.filter({$0["city"] as? String ?? "" == "Toronto"})
        arrActivity = Mapper<ActivityModel>().mapArray(JSONArray: list)
        tableView.reloadData()
    }
    
    func showLoginScreen() {
        let VC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController = UINavigationController(rootViewController: VC)
        window?.makeKeyAndVisible()
    }
    
    @objc func showFavouriteScreen() {
        let VC = FavouriteViewController(nibName: "FavouriteViewController", bundle: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func onLogout() {
        
        popupAlert(title: AppName, message: "are you sure want to logout?", actionTitles: ["No","Yes"], actions: [{ action1 in
            self.dismiss(animated: true, completion: nil)
        },{ action2 in
            SyncManager.sharedInstance.resetPreferences()
            self.showLoginScreen()
        }])
        
    }

    @IBAction func onSelectCity_Click(_ sender: UIButton) {
        setupDropdown()
    }
    
}

extension ActivitiesViewController {
    
    func configureDropDown(container : UIView, arrValues : [String]) -> DropDown{

        let dropDown = DropDown()
        dropDown.anchorView = container
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)! + 5))
        dropDown.dataSource = arrValues
        dropDown.semanticContentAttribute = .spatial
        dropDown.layer.cornerRadius = 20
        dropDown.textColor = .black
        dropDown.contentMode = .center
        dropDown.direction = .bottom
        dropDown.selectionBackgroundColor = .clear
        dropDown.width = container.frame.size.width
        dropDown.show()
        DropDown.startListeningToKeyboard()
        return dropDown
    }
}

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell {
            
            let model = arrActivity[indexPath.row]
            cell.imgActivity.setImage(url: model.photo?.first ?? "")
            cell.lblName.text = model.name ?? ""
            cell.lblPrice.text = "Price : $\(model.price ?? 0) / Person"
            cell.btnFavourite.isSelected = arrFavourites.contains(model.id ?? 1) ? true : false
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.addTarget(self, action: #selector(onFavourite_Click(_:)), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrActivity.count > 0 {
            let model = arrActivity[indexPath.row]
            let VC = ActivityDetailsVC(nibName: "ActivityDetailsVC", bundle: nil)
            VC.activity = model
            VC.index = indexPath.row
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func onFavourite_Click(_ sender: UIButton) {
        
        if arrActivity.count > 0 {
            let model = arrActivity[sender.tag]
            SyncManager.sharedInstance.favUnfavActivity(model: model, sender: sender)
        }
    }
}
