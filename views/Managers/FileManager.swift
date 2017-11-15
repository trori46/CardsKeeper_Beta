//
//  FileManager.swift
//  CardsKeeper
//
//  Created by Victoriia Rohozhyna on 11/14/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//

import Foundation
import UIKit

class FileManager {
    var imageString = ""
    
    func loadImageFromPath( date: Date, count: Int) -> UIImage? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        var pathURL: URL!
        if count == 1 {
            pathURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(date).jpg"))
        }else if count == 2 {
            pathURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(date)_2.jpg"))
        }else if count == 3 {
            pathURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(date)_3.jpg"))
        }
        do {
            let imageData = try Data(contentsOf: pathURL)
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func addToUrl(_ photo: UIImage, imageCount: Int, create: Date) -> String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if imageCount == 1 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(create).jpg"))
            imageString = String(describing: imgPath)
            do{
                try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
            return imageString
        } else if imageCount == 2 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(create)_2.jpg"))
            imageString = String(describing: imgPath)
            do{
                try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
            return imageString
        } else if imageCount == 3 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(create)_3.jpg"))
            imageString = String(describing: imgPath)
            print(imageString)
            do{
                try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
            return imageString
        }
        else {
            let imageString = ""
            return imageString
        }
        
    }

}
