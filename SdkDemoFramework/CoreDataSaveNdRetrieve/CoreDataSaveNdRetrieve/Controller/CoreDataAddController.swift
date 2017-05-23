//
//  CoreDataAddController.swift
//  CoreDataSaveNdRetrieve
//
//  Created by BonMac21 on 12/26/16.
//  Copyright © 2016 BonMac21. All rights reserved.
//

import UIKit
import CoreData

class CoreDataAddController: UITableViewController {
    
    @IBOutlet var tableViewAdd: UITableView!
    var teams = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addNameButton))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            teams = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func addNameButton () {
        let alert = UIAlertController(title: "New Team", message: "Add a Team", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok",
                                     style: .default,
                                     handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields?.first
                                        if textField?.text != "" {
                                            self.saveName(name: (textField?.text)!)
                                        }
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
    }
    
    func saveName(name: String) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        let person = Person(entity: entityDescription!, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        person.setValue("\(self.teams.count+1)", forKey: "team_id")
         do {
            try managedContext.save()
            teams.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewAdd.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let team = teams[indexPath.row]
        cell.labelText.text = team.value(forKey: "name") as! String!
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeList = self.storyboard?.instantiateViewController(withIdentifier: "CoreDataSecondController") as! CoreDataSecondController
        let team = teams[indexPath.row]
        employeeList.teamid  = team.value(forKey:"team_id") as! String
        self.navigationController?.pushViewController(employeeList, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
//            let eventToPass = self.teams[indexPath.row]
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let managedContext = appDelegate.persistentContainer.viewContext
//            managedContext.delete(eventToPass)
//            self.teams.remove(at: indexPath.row)
//            appDelegate.saveContext()
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        
//        let deleteActio = UITableViewRowAction(style: .normal, title: "Dele") { (action, index) in
//            
//        }
//        let deleteActi = UITableViewRowAction(style: .default, title: "De") { (action, index) in
//            
//        }
//        deleteActi.backgroundColor = UIColor.purple
//        deleteActio.backgroundColor = UIColor.orange
//        return [deleteAction,deleteActi,deleteActio]
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style:
        .destructive, title: "DELETE") { (action, index) in
            let eventToDelete = self.teams[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(eventToDelete)
            self.teams.remove(at: indexPath.row)
            appDelegate.saveContext()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }
}


