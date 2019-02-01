//
//  settingObject.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation

class setting {
    static let shared = setting()
    
    var distance:Int!
    var location: (latitude: Double, longitude: Double)
    private init(){
        self.distance = 100
        self.location = (latitude: 35.235, longitude: -80.857932)
    }
}
