//
//  CoreDataDetailController.swift
//  CoreDataSaveNdRetrieve
//
//  Created by BonMac21 on 12/29/16.
//  Copyright © 2016 BonMac21. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDetailController: UITableViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldDesignation: UITextField!
    var employeeid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Detail")
        let pred = NSPredicate(format :"(employee_id = %@)", employeeid)
        fetchRequest.predicate = pred
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                let dicResult = results[0] as! Detail
                self.textFieldName.text = dicResult.employeeName!
                self.textFieldAddress.text = dicResult.address!
                self.textFieldDesignation.text = dicResult.designation!
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    
    @IBAction func saveContact(_ sender: Any) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Detail", in: managedContext)
        let detail = Detail(entity: entityDescription!, insertInto: managedContext)
        detail.employeeName = textFieldName.text
        detail.address = textFieldAddress.text
        detail.designation = textFieldDesignation.text
        detail.employee_id = employeeid
        do {
            try managedContext.save()
            textFieldName.text = ""
            textFieldDesignation.text = ""
            textFieldAddress.text = ""
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            
        }
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }

  

   

}
