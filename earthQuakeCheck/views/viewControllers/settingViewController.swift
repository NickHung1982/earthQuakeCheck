//
//  settingViewController.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit

protocol settingDelegate{
    func reloadMainPageData()
}
class settingViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    var delegate:settingDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceLabel.text = "\(setting.shared.distance!)"

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         delegate.reloadMainPageData()
    }

    @IBAction func ChangeDistanceSliderValue(_ sender: UISlider) {
        
        distanceLabel.text = String(Int(sender.value))
        
    }
    
    //save distance value 
    @IBAction func clickSaveButton(_ sender: Any) {
        setting.shared.distance = Int(distanceLabel.text!)
       
    }
    
    

}
