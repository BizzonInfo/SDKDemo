//
//  CoreDataCollectionViewCell.swift
//  CoreDataSearchTask
//
//  Created by BonMac21 on 5/9/17.
//  Copyright © 2017 BonMac21. All rights reserved.
//

import UIKit

protocol TapCellDelegate: NSObjectProtocol {
    func buttonTapped(indexPath: IndexPath)
}


class CoreDataCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var labelItem: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var delegate : TapCellDelegate?
    public var indexPath: IndexPath!
    
    @IBAction func buttonDeletePressed(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.buttonTapped(indexPath: indexPath)
        }
    }
}
