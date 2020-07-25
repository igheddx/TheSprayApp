//
//  TableViewCell.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

//protocol example still good
//protocol PostCellDelegate {
//    func usernameClicked(_ cell: TableViewCell)
//}

protocol CustomCellDelegate : class {

    func buttonClickAtIndex() -> (Int)
}

class TableViewCell: UITableViewCell {
      
    //good protocol example
    //var delegate: PostCellDelegate?
    
//    @IBOutlet weak var theImage: UIImageView!
//    @IBOutlet weak var eventTitleLabel: UILabel!
//
//    @IBOutlet weak var eventTitleLabel2: UILabel!
//
//    @IBOutlet weak var eventTitleLabel: UILabel!
//
//    @IBOutlet weak var eventTitleLabel2: UILabel!
    
    @IBOutlet weak var invite : UIButton!
    weak var delegate : CustomCellDelegate?

     
    
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCityStateZipCountryLabel: UILabel!

    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    
//    @IBAction func usernameButtonAction(_ sender: Any) {
//        print("Username clicked")
//        self.delegate?.usernameClicked(self)
//    }
                      //rsvpLabel.isHidden = true
  
    //
    //                  print("it's RSVP")
    //
//    let switchDemo = UISwitch(frame:CGRect(x: 316, y: 224, width: 47, height: 31))
//    switchDemo.isOn = true
//    switchDemo.setOn(true, animated: false)
//    switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
//    self.view!.addSubview(switchDemo)
    
    
    func setEvent(event: EventData){
//        eventTitleLabel.text = event.name
//        eventTitleLabel2.text = event.address1
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
