//
//  Test2TableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/19/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class Test2TableViewCell: UITableViewCell {

    
    @IBOutlet weak var cardView2: UIView!
    @IBOutlet weak var pictureView2: UIImageView!

    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(picture: UIImage, title: String, description: String) {
        pictureView2.image = picture
        titleLabel2.text = title
        descriptionLabel2.text = description
        
        cardView2.layer.borderColor  = UIColor.gray.cgColor
        cardView2.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        cardView2.layer.shadowOpacity  = 1.0
        cardView2.layer.masksToBounds = false
        cardView2.layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
