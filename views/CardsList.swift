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




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PopoverDelegate,UIPopoverPresentationControllerDelegate {
    
    
    
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
    var cardArray:[Card] = []

    var filter: String = ""
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpSearchBar()
        if filter == "" {
            cardArray = cardsManager.fetchData()
        } else {
        cardArray = cardsManager.fetchData(filter: filter)
        }
        self.tableView.reloadData()
        print(cardArray)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pageenabled"){
            let detailController = segue.destination as? pageenabled
            detailController?.cardArray = sender as? Card
        } else if (segue.identifier == "popover"){
            let des = segue.destination as! Popover
            des.delegate = self
            des.popoverPresentationController?.delegate = self
        } else if (segue.identifier == "editting"){
            let editingController = segue.destination as? AddViewController
            editingController?.cardEditting = sender as! Card?
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
            let activityVc = UIActivityViewController(activityItems: [card.title, card.description, self.fileManager.loadImageFromPath(date: card.created, count: 1)!], applicationActivities: nil)
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
    
    
        performSegue(withIdentifier: "pageenabled", sender: cardArray[indexPath.row])
        
    }
    

}


