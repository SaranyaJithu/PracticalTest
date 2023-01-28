//
//  ProductTableViewCell.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 27/01/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var labelProductId: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
