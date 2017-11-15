//
//  ManagerCards.swift
//  views
//
//  Created by Victoriia Rohozhyna on 10/30/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class ManagerCards {
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    func saveObject(title: String, description: String, created: Date, cardFrontImage: String, cardBackImage: String, barCode: String, filter: String) {
        let newCard = Card(context: context)
        newCard.title = title
        newCard.descriptionCard  = description
        newCard.created = created
        newCard.cardFrontImage = cardFrontImage
        newCard.cardBackImage = cardBackImage
        newCard.barCode = barCode
        newCard.filter = filter
   
        do {
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
    func updateObject(card :Card, title: String, description: String, created: Date, cardFrontImage: String, cardBackImage: String, barCode: String, filter: String) {
        card.title = title
        card.descriptionCard  = description
        card.created = created
        card.cardFrontImage = cardFrontImage
        card.cardBackImage = cardBackImage
        card.barCode = barCode
        card.filter = filter
        
        do {
            try context.save()
        }
        catch{
            print(error)
        }
    }
    func fetchData(filter: String?) -> [Card] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            fetchRequest.predicate = NSPredicate(format: "filter == %@", filter!)
            var cardArray:[Card] = []
            do {
                
                cardArray = (try context.fetch(fetchRequest) as? [Card])!
                
            } catch {
                print(error)
                
            }
            return cardArray
        
    }
    func fetchData() -> [Card] {
        do {
            var cardArray:[Card] = []
        var request = NSFetchRequest<NSFetchRequestResult>()
        request = Card.fetchRequest()
        request.returnsObjectsAsFaults = false
            cardArray = try context.fetch(request) as! [Card]
    return cardArray
    } catch {
    let cardArray:[Card] = []
    return cardArray
    }
    }
    
    func delete (array: [Card], indexPath: IndexPath) {
        let card = array[indexPath.row]
        context.delete(card)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
 
}
