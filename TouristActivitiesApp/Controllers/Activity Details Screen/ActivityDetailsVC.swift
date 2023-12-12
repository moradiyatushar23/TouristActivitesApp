//
//  ActivityDetailsVC.swift
//  TouristActivitiesApp
//
//  Created by iMac on 21/11/21.
//

import UIKit
import Cosmos

class ActivityDetailsVC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    
    //MARK: - Variables
    var activity : ActivityModel?
    var index: Int = 0
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData() 
    }
    
    
    //MARK: - Custom Methods
    func initialConfig() {
        
        title = titleActivityDetails
        navigationController?.navigationBar.tintColor = UIColor.black
        collView.register(UINib(nibName: "ActivityImageCell", bundle: nil), forCellWithReuseIdentifier: "ActivityImageCell")
    }
    
    func setData() {
        lblTitle.text = activity?.name ?? ""
        lblPrice.text = "Price : $\(activity?.price ?? 0) / Person"
        lblHostName.text = activity?.host ?? ""
        lblDescription.text = activity?.description ?? ""
        lblContact.text = activity?.contact ?? ""
        
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .full
        ratingView.settings.starSize = 30
        ratingView.settings.starMargin = 5
        ratingView.rating = Double(activity?.rating ?? 0)
        
        if let arr = defaults.object(forKey: "favourite_list\(SyncManager.sharedInstance.getLoggedInUser())") {
            arrFavourites.removeAll()
            arrFavourites = arr as? [Int] ?? []
        }
        
        btnFavourite.isSelected = arrFavourites.contains(activity?.id ?? 1) ? true : false
    }
    
    
    
    //MARK: - @IBAction Methods
    @IBAction func onShare_Click(_ sender: UIButton) {
        let price = "Price : $\(activity?.price ?? 0) / Person"
        SyncManager.sharedInstance.shareActivity(name: activity?.name ?? "", price: price)
    }
    
    @IBAction func onFaviourite_Click(_ sender: UIButton) {
        if activity != nil {
            SyncManager.sharedInstance.favUnfavActivity(model: activity!, sender: sender)
        }
    }
    @IBAction func onContact_Click(_ sender: UIButton) {
        SyncManager.sharedInstance.onTapContact(number: activity?.contact ?? "555-555-555-555")
    }
    
}

extension ActivityDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activity?.photo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityImageCell", for: indexPath) as? ActivityImageCell {
            
            if activity?.photo?.count ?? 0 > 0 {
                let image = activity?.photo?[indexPath.row] ?? ""
                if image != "" {
                    cell.imgView.setImage(url: image)
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 200.0)
    }
}
