//
//  singleUserDefaults.swift
//  internationalAlarm
//
//  Created by essdessder on 5/18/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import Foundation

class singleUserDefaults
{
    static let shared = singleUserDefaults()
    let defaults = UserDefaults.standard
    func getSoundBool()->Bool{
        return defaults.bool(forKey: "sound")
    }

    func getrepeatBool()->Bool{
        return defaults.bool(forKey: "Repeat")
    }
    
    private init(){
        
        defaults.set(true, forKey: "sound")
        defaults.set(false, forKey: "Repeat")
    }
    
    
}
