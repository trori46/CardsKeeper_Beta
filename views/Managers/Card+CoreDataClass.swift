
//
//  Card+CoreDataClass.swift
//  
//
//  Created by Victoriia Rohozhyna on 11/3/17.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }
    
    @NSManaged public var created: Date
    @NSManaged public var descriptionCard: String
    @NSManaged public var filter: String
    @NSManaged public var title: String
    @NSManaged public var cardFrontImage: String
    @NSManaged public var cardBackImage: String
    @NSManaged public var barCode: String
    
}
