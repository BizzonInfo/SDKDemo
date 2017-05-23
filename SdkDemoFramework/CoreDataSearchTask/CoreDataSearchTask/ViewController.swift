//
//  ViewController.swift
//  CoreDataSearchTask
//
//  Created by BonMac21 on 5/9/17.
//  Copyright © 2017 BonMac21. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, TapCellDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionSearchBar: UISearchBar!
    
    var items:[NSManagedObject] = []
    var filteredItem = [NSManagedObject]()
    var filteredItemIndex = [Int]()
    var searchBarActive:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
             print("Could not fetch. \(error),\(error.userInfo)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonAddClicked(_sender: Any) {
        let alert = UIAlertController(title: "Enter the Details", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter Here"
            textfield.keyboardType = UIKeyboardType.default
            textfield.addTarget(alert, action: #selector(alert.textDidChangeInEnteringItem), for: .editingChanged)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertSave) in
            guard let itemId = alert.textFields?[0].text else {
                return
            }
            self.saveData(itemid: itemId)
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
   
    func saveData(itemid: String) {
        let managedContext = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext!)
        let iteM = NSManagedObject(entity: entity!, insertInto: managedContext)
        iteM.setValue(itemid, forKey: "itemid")
        items.append(iteM)
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.collectionView.reloadData()
    }
    
    func buttonTapped(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Hello", message: "Are you sure you want to deliver this", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) in
          self.deleteItem(indexOfItem: indexPath.row)
        }))
         present(alert, animated: true, completion: nil);
    }
    
    
    func deleteItem(indexOfItem: Int) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = items[indexOfItem]
        managedContext.delete(item)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.collectionSearchBar.text = ""
        self.collectionView.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(!self.searchBarActive){
            return items.count
        }
        else{
            return filteredItem.count
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CoreDataCollectionViewCell
       
        cell.delegate = self
        cell.indexPath = indexPath
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blue.cgColor
        if (!searchBarActive) {
             cell.labelItem.text = items[indexPath.row].value(forKeyPath: "itemid") as? String
        } else {
            cell.labelItem.text = filteredItem[indexPath.row].value(forKeyPath: "itemid") as? String
        }
       return cell
    }
    
    // MARK : Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchBarActive  = true
            myFetchRequest(searchString: searchBar.text)
        }else{
            self.searchBarActive = false
            self.collectionView?.reloadData()
        }
    }
    
    func myFetchRequest(searchString: String!) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        filteredItem.removeAll(keepingCapacity: false)
        filteredItemIndex.removeAll(keepingCapacity: false)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "itemid CONTAINS[cd] %@", searchString)
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for result in results {
                filteredItem.append(result)
                filteredItemIndex.append(items.index(of: result)!)
            }
            self.collectionView.reloadData()
            
        }catch let error {
            print(error)
        }
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        collectionView.reloadData()
    }
    
    func cancelSearching(){
        self.searchBarActive = false
        self.collectionSearchBar.resignFirstResponder()
        self.collectionSearchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionSearchBar.setShowsCancelButton(true, animated: false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        collectionSearchBar.setShowsCancelButton(false, animated: false)
        
    }
    
}

extension UIAlertController {
    
    func textDidChangeInEnteringItem() {
        if let itemid = textFields?[0].text, let actions = actions.last {
            actions.isEnabled = isValidItemId(itemid: itemid)
        }
    }
    
    func isValidItemId(itemid: String)-> Bool {
        return itemid.characters.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9]*$").evaluate(with: itemid)
    }
    
    
    
}

