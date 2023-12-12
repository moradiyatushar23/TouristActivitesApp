//
//  Constants.swift
//  TouristActivitiesApp
//
//  Created by iMac on 20/11/21.
//

import Foundation
import UIKit


// MARK: - Application Name
let AppName : String = "Tourist Activities"

// MARK: - Application Version
let AppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!

// MARK: - UserDefaults
let defaults = UserDefaults.standard


// MARK: - Size Constants
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height



//MARK: - String Constants

let titleActivity = "Activities"
let titleFavourites = "Favourites"
let titleActivityDetails = "Activity Detail"
