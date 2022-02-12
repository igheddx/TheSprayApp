//
//  Timer.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/22/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

public var newsImage = ""
let defaults = UserDefaults.standard

class SprayTimer {
    var timerTest: Timer? = nil
    var vc: ViewController?
    var count: Int = 0
    var newsImageParam: UIImageView?
    var messageLlb: UILabel?
    var output: String = ""
    //var newImage: UIImageView?
    
//    init(newsImageParam: UIImageView) {
//       let  img = newsImageParam
//            
//        }
    
    func startTimer () {
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target      : self,
            selector    : #selector(fireTimer),
            userInfo    : nil,
            repeats     : true)
    }

    func timerActionTest() {
        print(" timer condition \(timerTest)")
    }

    func stopTimerTest() {
        timerTest!.invalidate()
        timerTest = nil
    }
    
    @objc  func fireTimer() -> String {
    
      
        count = count + 1
        if count == 1 {
            print("image 111111")
            newsImage = "newimage1"
            defaults.set("newimage1", forKey: "myNewsImage")
            
//            newsImageParam!.image = UIImage(named: "newsimage1")
//            messageLlb!.text = "Better to give than to receive..."

            //newsimage.image = UIImage(named: "newsimage1")
            //newsLabel.text = "Better to give than to receive..."
        } else if count == 2 {
            print("image 2222222")
            newsImage = "newimage2"
            defaults.set("newimage2", forKey: "myNewsImage")
            //newsimage.image = UIImage(named: "newsimage2")
            //newsLabel.text = "Dancing in the street..."
            
//            newsImageParam!.image = UIImage(named: "newsimage2")
//            messageLlb!.text = "Dancing in the street..."
//
       
        } else if count == 3 {
           print("image 3333333")
            newsImage = "newimage3"
            defaults.set("newimage3", forKey: "myNewsImage")
            
//            newsImageParam!.image = UIImage(named: "newsimage3")
//            messageLlb!.text = "Show your appreciation, spray your friends..."
            //newsimage.image = UIImage(named: "newsimage3")
            //newsLabel.text = "Show your appreciation, spray your friends..."
            count = 0
        }
        
        return output
        //var newsImage: UIImageView?
        
        //newsImage!.image = UIImage(named: "newsimage1")
        //newsImage.image = UIImage(named: "newsimage1")
        //return newsImage!
        
    }
}
