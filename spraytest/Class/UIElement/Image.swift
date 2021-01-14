//
//  Image.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/15/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        assert(bounds.height == bounds.width, "The aspect ratio isn't 1/1. You can never round this image view!")

        layer.cornerRadius = bounds.height / 2
    }
}
