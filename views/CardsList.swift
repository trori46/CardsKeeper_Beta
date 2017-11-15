//
//  TableViewController.swift
//  views
//
//  Created by Victoriia Rohozhyna on 10/27/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import RSBarcodes_Swift
import CoreSpotlight
import MobileCoreServices
import LocalAuthentication

var isLog = false

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PopoverDelegate,UIPopoverPresentationControllerDelegate  {
    
    private var searchedSongIdentifier: Int?
    
    var selectedIndex: Int!
    
    
    func pressedButton(sorted: PopoverButton) {
        switch sorted{
                    case .az :
                      cardArray.sort() {  $0.title.lowercased() < $1.title.lowercased() }
                    tableView.reloadData();
                    case .za :
                        cardArray.sort() {  $0.title.lowercased() > $1.title.lowercased() }
                    tableView.reloadData();
                        case .dateUp : cardArray.sort() { $0.created < $1.created }
                        tableView.reloadData();
                    case .dateDown : cardArray.sort() { $0.created > $1.created }
                        tableView.reloadData();
            
                    }
    }
    
    var cardsManager = ManagerCards()
   var fileManager = FileManager()
    //var logManager = AuthenticationViewController()
    var cardArray:[Card] = []

    var filter: String = ""
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLog == false {
            authenticateUser()
        } else {
            navigateToAuthenticatedViewController()
        }
        if userActivity != nil {
            restoreUserActivityState(userActivity!)
        }
       
    }
    
    func navigateToAuthenticatedViewController(){
        DispatchQueue.main.async() {
            self.initSearchableItems()
            self.tableView.dataSource = self
            self.tableView.delegate = self
        
            self.setUpSearchBar()
            if self.filter == "" {
                self.cardArray = self.cardsManager.fetchData()
        } else {
                self.cardArray = self.cardsManager.fetchData(filter: self.filter)
        }
        self.tableView.reloadData()
            print(self.cardArray)
            self.tableView.estimatedRowHeight = 106
            
          
        }
    }
    
    
    func initSearchableItems() {
        
        var searchableItems: [CSSearchableItem] = []
        if cardArray.count != 0 {
        for i in 0...cardArray.count-1 {
            let name = cardArray[i]
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            attributeSet.title = name.title
            attributeSet.contentDescription = name.descriptionCard + "\n" + String(describing: name.created)
            
            var keywords = name.title.components(separatedBy: " ")
            keywords.append(name.title)
            
            attributeSet.keywords = keywords
            //attributeSet.contentDescription = name.descriptionCard
            let searchableItem = CSSearchableItem(uniqueIdentifier: String(i), domainIdentifier: "Cards", attributeSet: attributeSet)
            searchableItems.append(searchableItem)
            
        }
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error == nil {
                print("Searchable items were indexed successfully")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        }
        
    }
    
    func  authenticateUser() {

        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?

        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {

            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return

        }

        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in

                if( success ) {
                    isLog = true
                    // Fingerprint recognized
                    // Go to view controller
                    self.navigateToAuthenticatedViewController()

                }else {

                    // Check if there is an error
                    if let error = error {

                        let message = self.errorMessageForLAErrorCode(errorCode: error as! Int)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)

                    }

                }

        })

    }


    func errorMessageForLAErrorCode( errorCode:Int ) -> String{

        var message = ""

        switch errorCode {

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

            //        case LAError.touchIDLockout.rawValue:
            //            message = "Too many failed attempts."
            //
            //        case LAError.touchIDNotAvailable.rawValue:
            //            message = "TouchID is not available on the device"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = "Did not find error code on LAError object"

        }

        return message

    }

    func showAlertViewIfNoBiometricSensorHasBeenDetected(){

        //showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        navigateToAuthenticatedViewController()
    }

    /**
     This method will present an UIAlertViewController to inform the user that there was a problem with the TouchID sensor.

     - parameter error: the error message

     */
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){

        showAlertWithTitle(title: "Error", message: message)

    }

    /**
     This method presents an UIAlertViewController to the user.
     
     - parameter title:  The title for the UIAlertViewController.
     - parameter message:The message for the UIAlertViewController.
     
//     */
    func showAlertWithTitle( title:String, message:String ) {

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)

    }

    
    
    @IBAction func filterTableView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filter = ""
            cardArray = cardsManager.fetchData()
          tableView.reloadData()
    }        else if sender.selectedSegmentIndex == 1 {
            filter = "Shop"
            cardArray = cardsManager.fetchData(filter: filter)
            
            tableView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            filter = "Cafe"
            cardArray = cardsManager.fetchData(filter: filter)
            tableView.reloadData()
        } else if sender.selectedSegmentIndex == 3 {
            filter = "Beauty"
            cardArray = cardsManager.fetchData(filter: filter)
            
            tableView.reloadData()
        } else  {
            filter = "Another"
            cardArray = cardsManager.fetchData(filter: filter)
            tableView.reloadData()
        }
      
        
    }
        
  
    
   
    
   func filterTableView(text: String) {

            cardArray = cardArray.filter({ (mod) -> Bool in
                return (mod.title.lowercased().contains(text.lowercased()))
            })
            self.tableView.reloadData()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "pageenabled"){
            var songId: Int?
            if let index = tableView.indexPathForSelectedRow?.row {
                songId = index
            } else {
                songId = searchedSongIdentifier
            }
            let controller = segue.destination as! pageenabled
            controller.cardArray = cardArray[songId!]
//            let detailController = segue.destination as? pageenabled
//            detailController?.cardArray = sender as? Card
        } else if (segue.identifier == "popover"){
            let des = segue.destination as! Popover
            des.delegate = self
            des.popoverPresentationController?.delegate = self
        } else if (segue.identifier == "editting"){
            let editingController = segue.destination as? AddViewController
            editingController?.cardEditting = sender as! Card?
        }
//        } else {
//            if let index = tableView.indexPathForSelectedRow?.row {
//            Id = index
//        } else {
//            Id = searchedSongIdentifier
//        }
//            let controller = segue.destination as! pageenabled
//        controller.cardArray = cardArray[Id!]
//        }
    }
    
    
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType {
            if let identifier = Int(activity.userInfo?[CSSearchableItemActivityIdentifier] as! String) {
                searchedSongIdentifier = identifier
                performSegue(withIdentifier: "pageenabled", sender: cardArray[identifier])
            }
        }
    }
    
    fileprivate func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            if self.filter == "" {
                self.cardArray = (self.cardsManager.fetchData())
            } else {
                self.cardArray = (self.cardsManager.fetchData(filter: self.filter))
            }
             self.tableView.reloadData()
        }else {
            filterTableView(text: searchText)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(cardArray.count)
        print(cardArray)
        return cardArray.count
    }
 func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let share =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            let card = self.cardArray[indexPath.row]
            let activityVc = UIActivityViewController(activityItems: [card.title, card.descriptionCard, self.fileManager.loadImageFromPath(date: card.created, count: 1)!], applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = self.view

            self.present(activityVc, animated: true, completion: nil)
            completionHandler(true)
        })
    
       let edit =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            
            self.performSegue(withIdentifier: "editting", sender: self.cardArray[indexPath.row])
        })
            let delete =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                self.cardsManager.delete(array: self.cardArray, indexPath: indexPath)
                if self.filter == "" {
                    self.cardArray = (self.cardsManager.fetchData())
                } else {
                    self.cardArray = (self.cardsManager.fetchData(filter: self.filter))
                }
                
            tableView.reloadData()
            })

        
//        share.backgroundColor = UIColor (patternImage: #imageLiteral(resourceName: "share"))
        share.image = UIImage(named: "share.png")
        edit.image = UIImage(named: "edit.png")
        delete.image = UIImage(named: "delete.png")
        let confrigation = UISwipeActionsConfiguration(actions: [share, edit, delete])
        
        return confrigation
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let name = cardArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.filter.text = name.filter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.titleLabel.text = name.title
        cell.descriptionLabel.text = name.descriptionCard
            let dateFormat = dateFormatter.string(from: name.created as Date)
            cell.date.text = dateFormat
        cell.frontImage!.image = fileManager.loadImageFromPath( date: name.created as Date, count: 1)
        
        // Configure the cell...
        return cell
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
       selectedIndex = indexPath.row
        performSegue(withIdentifier: "pageenabled", sender: cardArray[indexPath.row])
        
    }
    

                }


