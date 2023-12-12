//
//  FavouriteViewController.swift
//  TouristActivitiesApp
//
//  Created by iMac on 21/11/21.
//

import UIKit
import ObjectMapper

class FavouriteViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    var arrFavActivity : [ActivityModel] = [ActivityModel]()
    
    
   //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBarButtons()
        setData()
    }
    
    
    //MARK: - Custom Methods
    func initialConfig() {
        
        title = titleFavourites
        navigationController?.navigationBar.tintColor = UIColor.black
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
    }
    
    func addNavigationBarButtons() {
        
        let deleteButton = UIBarButtonItem(image: UIImage(named: "delete"),  style: .plain, target: self, action: #selector(onDelete))
        navigationItem.rightBarButtonItems = [deleteButton]
    }
    
    @objc func onDelete() {
        
        popupAlert(title: AppName, message: "are you sure want to unfaviourite all activities?", actionTitles: ["No","Yes"], actions: [{ action1 in
            self.dismiss(animated: true, completion: nil)
        },{ action2 in
            arrFavourites.removeAll()
            self.arrFavActivity.removeAll()
            defaults.set(arrFavourites, forKey: "favourite_list\(SyncManager.sharedInstance.getLoggedInUser())")
            self.tableView.reloadData()
            self.viewNoData.isHidden = arrFavourites.count != 0
        }])
        
    }
    
    func setData() {
        
        arrFavourites.removeAll()
        if let arr = defaults.object(forKey: "favourite_list\(SyncManager.sharedInstance.getLoggedInUser())") {
            arrFavourites = arr as? [Int] ?? []
        }
        
        let arrAll = Mapper<ActivityModel>().mapArray(JSONArray: arrAllActivity)
        arrFavActivity.removeAll()
        for item in arrAll {
            for id in arrFavourites {
                if id == item.id {
                    arrFavActivity.append(item)
                }
            }
        }
        viewNoData.isHidden = arrFavActivity.count != 0
        tableView.reloadData()
    }
    
    
    //MARK: - @IBAction Methods

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell {
            
            let model = arrFavActivity[indexPath.row]
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
        if arrFavActivity.count > 0 {
            let model = arrFavActivity[indexPath.row]
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
        
        if arrFavActivity.count > 0 {
            let model = arrFavActivity[sender.tag]
            SyncManager.sharedInstance.favUnfavActivity(model: model, sender: sender)
            setData()
        }
    }
}
