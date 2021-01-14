//
//  TestTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/19/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var pictureView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(picture: UIImage, title: String, description: String) {
        pictureView.image = picture
        titleLabel.text = title
        descriptionLabel.text = description
        
        cardView.layer.borderColor  = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        cardView.layer.shadowOpacity  = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
