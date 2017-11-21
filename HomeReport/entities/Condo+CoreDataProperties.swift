//
//  Condo+CoreDataProperties.swift
//  HomeReport
//
//  Created by Piotr Wesolowski on 21/11/2017.
//  Copyright © 2017 Piotr Wesolowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Condo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Condo> {
        return NSFetchRequest<Condo>(entityName: "Condo")
    }

    @NSManaged public var unitsPerBuilding: Int16

}
