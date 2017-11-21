//
//  SingleFamily+CoreDataProperties.swift
//  HomeReport
//
//  Created by Piotr Wesolowski on 21/11/2017.
//  Copyright © 2017 Piotr Wesolowski. All rights reserved.
//
//

import Foundation
import CoreData


extension SingleFamily {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleFamily> {
        return NSFetchRequest<SingleFamily>(entityName: "SingleFamily")
    }

    @NSManaged public var lotSize: Int16

}
