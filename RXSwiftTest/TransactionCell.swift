//
//  TransactionCell.swift
//  RXSwiftTest
//
//  Created by Sunith B on 31/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
