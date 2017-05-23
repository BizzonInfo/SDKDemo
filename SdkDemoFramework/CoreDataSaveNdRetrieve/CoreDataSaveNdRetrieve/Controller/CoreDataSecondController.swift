//
//  CoreDataSecondController.swift
//  CoreDataSaveNdRetrieve
//
//  Created by BonMac21 on 12/26/16.
//  Copyright © 2016 BonMac21. All rights reserved.
//

import UIKit
import CoreData

class CoreDataSecondController: UITableViewController {

    @IBOutlet var tableViewAdd: UITableView!
    var teams = [NSManagedObject]()
    var teamid = ""
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        let pred = NSPredicate(format : "(team_id = %@)", teamid)
        fetchRequest.predicate = pred
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            teams = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func addNameButton () {
        let alert = UIAlertController(title: "New Employees", message: "Add a Employees", preferredStyle: .alert)
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
        let entityDescription = NSEntityDescription.entity(forEntityName: "Employees", in: managedContext)
        let employee = Employees(entity: entityDescription!, insertInto: managedContext)
        employee.employName = name
        employee.team_id = teamid
        employee.setValue("\(self.teams.count+1)", forKey: "employee_id")
        do {
            try managedContext.save()
            teams.append(employee)
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
        //        let appDelegate =
        //            UIApplication.shared.delegate as! AppDelegate
        //        let managedContext = appDelegate.persistentContainer.viewContext
        //        let entityDescription = NSEntityDescription.entity(forEntityName: "Employees", in: managedContext)
        //        let person = Employees(entity: entityDescription!, insertInto: managedContext)
        //        person.setValue(indexPath.row, forKey: "employee_id")
        //        do {
        //            try managedContext.save()
        //            teams.append(person)
        //        } catch let error as NSError  {
        //            print("Could not save \(error), \(error.userInfo)")
        //        }
        let team = teams[indexPath.row]
        cell.labelText.text = team.value(forKey: "employName") as! String?
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailList = self.storyboard?.instantiateViewController(withIdentifier: "CoreDataDetailController") as! CoreDataDetailController
        let detail = teams[indexPath.row]
        detailList.employeeid = detail.value(forKey: "employee_id") as! String
        self.navigationController?.pushViewController(detailList, animated: true)
    }
    
    
    
}
