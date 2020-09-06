//
//  AlarmItem+CoreDataProperties.swift
//  internationalAlarm
//
//  Created by essdessder on 5/13/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
//
// Created by Yusen Chen. essdessder is my mac name/ online handle

import Foundation
import CoreData


extension AlarmItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmItem> {
        return NSFetchRequest<AlarmItem>(entityName: "AlarmItem")
    }

    @NSManaged public var location: String?
    @NSManaged public var time: String?
    @NSManaged public var date: String?
    @NSManaged public var note: String?
    @NSManaged public var uustring: String
    
}
