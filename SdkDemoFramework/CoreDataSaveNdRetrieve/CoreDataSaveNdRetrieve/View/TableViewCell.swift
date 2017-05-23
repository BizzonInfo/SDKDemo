//
//  TableViewCell.swift
//  CoreDataSaveNdRetrieve
//
//  Created by BonMac21 on 12/26/16.
//  Copyright © 2016 BonMac21. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
