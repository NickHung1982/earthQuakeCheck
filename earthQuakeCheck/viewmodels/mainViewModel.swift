//
//  mainViewModel.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



class mainViewModel {
    private var earthQuakeObjsList = [earthQuakeObj]()
    private var locationManager:CLLocationManager = CLLocationManager()
    
    public var getLocationManager: CLLocationManager {
        return locationManager
    }
    

    public var getListCount: Int {
       return earthQuakeObjsList.count
    }
    
    public func getCellData(indexPath: IndexPath) -> earthQuakeObj {
        let tmpObj = earthQuakeObjsList[indexPath.row]
        return tmpObj
    }
    
    public func getDateString(_ inputDate: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: inputDate)
    }
    
    public func updateSettingLocation(location: CLLocation) {
        //update setting
        setting.shared.location.latitude = location.coordinate.latitude
        setting.shared.location.longitude = location.coordinate.longitude
    }
  
    public func loadData(location: CLLocation, completionHandler:@escaping (Bool) -> ()) {
        let networking = HTTPNetworking()
        networking.getEarthQuakeObjs(location: location, completion: { objs in
            self.earthQuakeObjsList = objs
            completionHandler(true)
        })
        
    
    }
    
    init(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
 
        
    }
    
    func showAlert(_ text:String) {
        let alertVC = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action_OK = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertVC.addAction(action_OK)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alertVC, animated: true, completion: nil)
        }
        
        
    }
}
