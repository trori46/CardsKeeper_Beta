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


class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  ShittyDelegate {
    var cardsManager = ManagerCards()
    var imageString = ""
    let createdval = Date()
    var cardEditting : Card?
    var fileManager = FileManager()
    @IBOutlet weak var barCode: UIImageView!
    @IBOutlet weak var titleCard: UITextField!
    @IBOutlet weak var descriptionCard: UITextField!
    @IBOutlet weak var barCodeString: UITextField!
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var roundButton1: UIButton!
    
    @IBAction func generateBarCode(_ sender: UIButton) {
       
        let barCode: String = barCodeString.text!
        self.barCode?.image = RSUnifiedCodeValidator.shared.stringValidtoImage(barCode: barCode)

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
    

   
    @IBAction func createCard(_ sender: UIButton) {
        if titleCard?.text != "" && descriptionCard?.text != "" {
            let cardFrontImage = fileManager.addToUrl((fronImage?.image)!, imageCount: 1, create: createdval)
                let cardBackImage = fileManager.addToUrl((backImage?.image)!, imageCount: 2, create: createdval)
            let barCode = fileManager.addToUrl((self.barCode?.image)!, imageCount: 3, create: createdval)

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
            fronImage.image = fileManager.loadImageFromPath(date: (cardEditting?.created)!, count: 1)
            backImage.image = fileManager.loadImageFromPath(date: (cardEditting?.created)!, count: 2)
            barCode.image = fileManager.loadImageFromPath(date: (cardEditting?.created)!, count: 3)
        }
        // Do any additional setup after loading the view.
//        choose()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}


