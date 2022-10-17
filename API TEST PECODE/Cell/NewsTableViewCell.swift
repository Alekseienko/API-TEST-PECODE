//
//  NewsTableViewCell.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgName: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var descriptionName: UILabel!
    @IBOutlet weak var autorName: UILabel!
    @IBOutlet weak var sourseName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgName.layer.cornerRadius = 8.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
