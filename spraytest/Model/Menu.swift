//
//  Menu.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/1/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit
struct MenuData {
    var sectionName: String
    var sectionDetails: [MenuSections]

    init?(sectionName: String, sectionDetails: [MenuSections]){
          self.sectionName = sectionName
          self.sectionDetails = sectionDetails
    }
}

struct MenuSections {
    var name: String?
    var image: String?
    var viewcontroller: String?
}


struct MenuSectionMorActions {
    var name: String?
    var image: String?
    var viewcontroller: String?
}

struct MenuSectionNotifications {
    var name: String?
    var image: String?
    var viewcontroller: String?
}
struct MenuSectionLogout {
    var name: String?
    var image: String?
    var viewcontroller: String?
}
