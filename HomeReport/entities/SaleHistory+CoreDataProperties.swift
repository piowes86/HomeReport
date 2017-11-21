//
//  SaleHistory+CoreDataProperties.swift
//  HomeReport
//
//  Created by Piotr Wesolowski on 21/11/2017.
//  Copyright © 2017 Piotr Wesolowski. All rights reserved.
//
//

import Foundation
import CoreData


extension SaleHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaleHistory> {
        return NSFetchRequest<SaleHistory>(entityName: "SaleHistory")
    }

    @NSManaged public var soldDate: String?
    @NSManaged public var soldPrice: Double
    @NSManaged public var home: Home?

}
