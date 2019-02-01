//
//  main.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit
import CoreLocation



class mainTableViewController: UITableViewController {
    var model:mainViewModel!
    var activityView:UIActivityIndicatorView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicatory()
        
        model = mainViewModel()
        model.getLocationManager.delegate = self
        
    }
    
    //loading indicatory on navigationbar
    func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.hidesWhenStopped = true
        let barButton = UIBarButtonItem(customView: activityView)
        self.navigationItem.setLeftBarButton(barButton, animated: true)

        activityView.startAnimating()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.getListCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! mainCell

        let cellData = model.getCellData(indexPath: indexPath)
        cell.titleLabel.text = cellData.title
        cell.dateLabel.text = model.getDateString(cellData.time)

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //show web when user click
        let webviewDest = webviewViewController()
        webviewDest.weburl = model.getCellData(indexPath: indexPath).url
        self.navigationController?.pushViewController(webviewDest, animated: true)
     

    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSetting" {
            let dist = segue.destination as! settingViewController
            dist.delegate = self
        }
    }
    
    @IBAction func clickReloadButton(_ sender: Any) {
        
        model.getLocationManager.startUpdatingLocation()
        
    }
    
}

extension mainTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        if let userLocation = locations.last {

            model.updateSettingLocation(location: userLocation)
            
            model.loadData(location: userLocation,completionHandler: { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            })
            
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

extension mainTableViewController: settingDelegate {
    func reloadMainPageData() {
        
        let location = CLLocation(latitude: setting.shared.location.latitude, longitude: setting.shared.location.longitude)
        showActivityIndicatory()
        model.loadData(location: location,completionHandler: { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityView.stopAnimating()
            }
        })
        
        
    }
}
