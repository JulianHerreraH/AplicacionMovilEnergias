//
//  ARTableCellTableViewCell.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/17/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class ARTableCellTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTitleText: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellDataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellImage.layer.cornerRadius = 5
        // Configure the view for the selected state
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0;//Your custom row height
    }
}
