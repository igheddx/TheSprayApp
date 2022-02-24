//
//  QRScanner3ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/22/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanner3ViewController: UIViewController {
    var counter: Int = 0
    var completionAction: String = ""
    var completionAction2: String = ""
    var paymentClientToken: String = ""
    var token: String = ""
    var profileId: Int64 = 0
    var eventOwnerProfileId: Int64 = 0
    var eventId2: Int64 = 0
    var myProfileData: [MyProfile] = []
    
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var phone: String =  ""
    var encryptedAPIKey: String = ""
    var country: String = ""
    var isPaymentMethodAvailable: Bool = false
    
    var theEventId: Int64 = 0
   //theEventId = Int64(qrCodeData[4])!
    var theOwnerId: Int64 = 0
   // theOwnerId = Int64(qrCodeData[5])!
    
    var theEventType: String = ""
    var theIsSingleReceiverEvent: String = ""
        
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchScanner()
        // Do any additional setup after loading the view.
    }
    
    func launchScanner() {
//        let nextVC = storyboard?.instantiateViewController(withIdentifier: "QRScanner2ViewController") as! QRScanner2ViewController
//
//        self.navigationController?.pushViewController(nextVC , animated: true)
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRScanner2ViewController") as! QRScanner2ViewController
//
//        self.navigationController?.pushViewController(vc, animated: true)
//
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "QRScanner2ViewController") as! QRScanner2ViewController
       
        nextVC.profileId = profileId
        //nextVC.ownerId = ownerId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.myProfileData = myProfileData
        
        //        nextVC.eventId = eventId
//        nextVC.profileId = profileId
//        nextVC.token = token!
//        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.completionAction = "postloginscan"//completionAction //"callspraycandidate"
//        nextVC.isPaymentMethodAvailable = isPaymentMethodGeneralAvailable
//        nextVC.receiverName = receiverName
//        nextVC.isSingleReceiverEvent = isSingleReceiver
//        nextVC.hasPaymentMethodEvent = eventHasPaymentMethod
//        nextVC.isRsvprequired = isRsvprequired
//        nextVC.defaultEventPaymentMethod = paymentMethodId
//        nextVC.defaultEventPaymentCustomName = paymentCustomName
//        nextVC.refreshscreendelegate = self
//        nextVC.paymentClientToken = paymentClientToken
//        nextVC.processspraytrandelegate = self
//        nextVC.haspaymentdelegate = self
//        nextVC.eventOwnerProfileId = eventOwnerId
//        nextVC.country = country
//        nextVC.currencyCode = currencyCode
//        nextVC.myProfileData = myProfileData
//
        nextVC.modalPresentationStyle = .fullScreen
        
        self.present(nextVC, animated:false, completion:nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
