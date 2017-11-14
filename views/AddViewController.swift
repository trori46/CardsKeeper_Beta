//
//  CreatedViewController.swift
//  views
//
//  Created by Victoriia Rohozhyna on 10/27/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift
import AVFoundation
import QuartzCore


class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  ShittyDelegate{
    var cardsManager = ManagerCards()
    var imageString = ""
    let createdval = Date()
    var cardEditting : Card?
   
    @IBOutlet weak var barCode: UIImageView!
    @IBOutlet weak var titleCard: UITextField!
    @IBOutlet weak var descriptionCard: UITextField!
    @IBOutlet weak var barCodeString: UITextField!
    
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var roundButton1: UIButton!
    
    @IBAction func generateBarCode(_ sender: UIButton) {
       
        let barCode: String = barCodeString.text!
        
        if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
            {
                self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue )
        } else if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code128.rawValue) {
            self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code128.rawValue)
        } else if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39Mod43.rawValue) {
            self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39Mod43.rawValue)
        } else if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue) {
            self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue)
        } else if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue) {
            self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue)
        } else if RSUnifiedCodeValidator.shared.isValid(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) {
            self.barCode?.image = RSUnifiedCodeGenerator.shared.generateCode(barCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
        }
        imageCount = 3

        }
    
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var fronImage: UIImageView!
    
    @IBOutlet weak var backImage: UIImageView!
    var iImage: UIImage!
    var imageCount = 0
    
        @IBAction func frontImage(_ sender: UIButton) {
        picker()
        imageCount = 1
    }
     @IBAction func backImage(_ sender: UIButton) {
        picker()
        imageCount = 2
    }
    
    
    
    func picker(){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        imagePicker.delegate = self
        self.present(alert, animated: true, completion: nil)

        
    }
 
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            
            //imagePicker.resizableCropArea = true
//            UIImagePickerControllerCropRect(CGRect(x: 0, y: 30, width: 300, height: 100))
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //You will get cropped image here..
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            let shittyVC = ShittyImageCropVC(frame: (self.view.frame), image: image, aspectWidth: 5, aspectHeight: 3)
            self.present(shittyVC, animated: true, completion: nil)
           shittyVC.delegate = self
            
        }
    }
    
   

    
    func setImage(pickedImage: UIImage) {
        
    if imageCount == 1 {
    fronImage?.image = pickedImage
    
    }else if imageCount == 2 {
    backImage?.image = pickedImage
    
    }else if imageCount == 3 {
    barCode?.image = pickedImage
    
    }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addToUrl(_ photo: UIImage, imageCount: Int) -> String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if imageCount == 1 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(createdval).jpg"))
            imageString = String(describing: imgPath)
            do{
                try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
             return imageString
        } else if imageCount == 2 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(createdval)_2.jpg"))
            imageString = String(describing: imgPath)
            do{
                try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
             return imageString
        } else if imageCount == 3 {
            let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(createdval)_3.jpg"))
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
    
   
    @IBAction func createCard(_ sender: UIButton) {
        if titleCard?.text != "" && descriptionCard?.text != "" {
                let cardFrontImage = addToUrl((fronImage?.image)!, imageCount: 1)
                let cardBackImage = addToUrl((backImage?.image)!, imageCount: 2)
                let barCode = addToUrl((self.barCode?.image)!, imageCount: 3)

            var filter : String = ""
            if segment.selectedSegmentIndex == 0 {
                filter = "Shop"
            } else if segment.selectedSegmentIndex == 1 {
                filter = "Cafe"
            } else if segment.selectedSegmentIndex == 2 {
                filter = "Beauty"
            } else if segment.selectedSegmentIndex == 3 {
                filter = "Another"
            } else  {
                filter = "Another"
            }

            if cardEditting != nil {
                cardsManager.updateObject(card: cardEditting!, title: titleCard!.text!, description: descriptionCard!.text!, created: createdval, cardFrontImage: cardFrontImage, cardBackImage: cardBackImage, barCode: barCode, filter: filter)
            }else {
                cardsManager.saveObject(title: titleCard!.text!, description: descriptionCard!.text!, created: createdval, cardFrontImage: cardFrontImage, cardBackImage: cardBackImage, barCode: barCode, filter: filter)
            }
        } else {
            let alertVC = UIAlertController(title: "Error", message: "please fill all fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
    roundButton.layer.cornerRadius = 10
        roundButton1.layer.cornerRadius = 10
        fronImage.layer.masksToBounds = true
    fronImage.layer.cornerRadius = 10
        backImage.layer.masksToBounds = true
    backImage.layer.cornerRadius = 10
        barCode.layer.masksToBounds = true
    barCode.layer.cornerRadius = 10
 self.fronImage.isUserInteractionEnabled = true
        if cardEditting != nil {
            titleCard!.text = cardEditting?.title
            descriptionCard.text = cardEditting?.descriptionCard
            fronImage.image = loadImageFromPath(date: (cardEditting?.created)!, count: 1)
            backImage.image = loadImageFromPath(date: (cardEditting?.created)!, count: 2)
            barCode.image = loadImageFromPath(date: (cardEditting?.created)!, count: 3)
        }
        // Do any additional setup after loading the view.
//        choose()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//extension UIImage
//{
//    // convenience function in UIImage extension to resize a given image
//    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
//    {
//        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        self.draw(in: imgRect)
//        let copied = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return copied!
//    }
//}

