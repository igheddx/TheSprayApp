//
//  ScannerViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//


import UIKit
import AVFoundation


struct AddInvitee: Model {
    let profileId: Int64
    let eventId: Int64
    let eventInvitees: [AddInvitee2]
}

struct AddInvitee2: Model {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let profileId: Int64
}

    



class ScannerViewController: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    var completionAction: String = ""
 
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
  
 
    var theEventId: Int64 = 0
   //theEventId = Int64(qrCodeData[4])!
    var theOwnerId: Int64 = 0
   // theOwnerId = Int64(qrCodeData[5])!
    
    var theEventType: String = ""
    var theIsSingleReceiverEvent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for myprofile in myProfileData {
            firstname = myprofile.firstName
            lastname = myprofile.lastName
            email = myprofile.email
            phone = myprofile.phone
            
            print("I am in scanner and my name is \(firstname )")
            print("I am in scanner and my name is \(lastname )")
            print("I am in scanner and my name is \(email)")
            print("I am in scanner and my name is \(phone)")
        }
        
        openScanner()
    }
    
   func openScanner() {
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
            } else {
                self.failed()
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            self.avCaptureSession.startRunning()
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
        
//        self.dismiss(animated: true, completion: {
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
//        })
        
        //remove scanner VC from the stack when going back to home VC
        navigationController!.removeViewController(ScannerViewController.self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func addinvitees(myProfileId: Int64, firstName: String, lastName: String, email: String, phone: String, eventId: Int64, ownerProfileId: Int64) {
        
        let addInvitees = AddInvitee(profileId: ownerProfileId, eventId: eventId, eventInvitees: [AddInvitee2(firstName: firstName, lastName: lastName, email: email, phone: phone, profileId: myProfileId)])
            // JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
        
        print("token = \(token)")
        print("addInvitees= \(addInvitees)")
        
        let request = PostRequest(path: "/api/Event/addinvitees", model: addInvitees, token: token, apiKey: encryptedAPIKey, deviceId: "")
        
        

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                //RSVP
                print("CALLED RSVP")
                self.rsvp(eventIdvar: eventId, ownerId: ownerProfileId)
                break
            case .failure(let error):
                print(error.localizedDescription)
                //localizedDescriptionif error.localizedDescription
                //self.rsvp(eventIdvar: eventId, ownerId: ownerProfileId)
                
                
            }
        }
    }
    func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String, eventId: Int64, ownerId: Int64) {
        
//        var eid: Int64 = Int64(eventId)!
//        var oid: Int64 = Int64(ownerId)!
        
        let Invite =  JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
        
        print("Invite = \(Invite)")
        let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")


        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                //RSVP
                self.rsvp(eventIdvar: eventId, ownerId: ownerId)
                break
            case .failure(let error):
                print(error.localizedDescription)
                //localizedDescriptionif error.localizedDescription
                self.rsvp(eventIdvar: eventId, ownerId: ownerId)
                
                
            }
        }

    }
    
    func rsvp(eventIdvar: Int64, ownerId: Int64) {
//        let eventOwnerId = Int64(ownerId)!
//        let eventid = Int64(eventId)!
        
        eventOwnerProfileId = ownerId
        eventId2 = eventIdvar
        
        print("RSVP eventOwnerId \(eventOwnerProfileId)")
        print("RSVP eventid  \(eventId2)")
       
        
        
        let addAttendee = AddAttendees(profileId: eventOwnerProfileId, eventId: eventId2, eventAttendees: [Attendees(profileId: profileId, firstName: firstname, lastName: lastname, email: email, phone: phone, eventId: eventId2, isAttending: true)])
        
        print("addAttendee = \(addAttendee)")
        //let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
        print("RSVP \(firstname )")
        print("RSVP \(lastname )")
        print("RSVP \(email)")
        print("RSVP \(phone)")
        
        //print(updateAttendee)
        //isRefreshScreen = true
        let request = PostRequest(path: "/api/Event/addattendees", model: addAttendee, token: token, apiKey: encryptedAPIKey, deviceId: "")
            Network.shared.send(request) { (result: Result<Empty, Error>)  in
                    switch result {
                    case .success( _):
                        self.launchVC()
                        break
                    //case .failure(let error):
                    case .failure(let error):
//                        self.generalMessage.text = "The Application is Temporary Unavailable. Please try again shortly. \(error.localizedDescription)"
//                        self.generalMessage.textColor = UIColor(red: 193/256, green: 37/256, blue: 22/256, alpha: 1.0)
                        //self.messageLabel.text = error.localizedDescription
                        print(error.localizedDescription)
            }
        }
    }
    
    func launchVC() {
        
      
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.eventType =  theEventType
        nextVC.eventOwnerId = theOwnerId
            
       self.navigationController?.pushViewController(nextVC , animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
extension ScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
        print("i have dismissed")
    }
    
    func found(code: String) {
        print(code)
        //let str = "Andrew, Ben, John, Paul, Peter, Laura"
        let qrCodeData = code.components(separatedBy: "| ")
        print("arry =\(qrCodeData)")
        //let qrCodeData: [String] = [code]
        
       
        let theEventName = qrCodeData[0]
        let theEventDateTime = qrCodeData[1]
        let theEventCode = qrCodeData[2]
        let theEventImage = qrCodeData[3]
        //let theEventId = Int64(qrCodeData[4])
        //let theOwnerId = Int64(qrCodeData[5])
       // var theEventId: Int64 = 0
        theEventId = Int64(qrCodeData[4])!
            //var theOwnerId: Int64 = 0
        theOwnerId = Int64(qrCodeData[5])!
        
        theEventType = qrCodeData[6]
        theIsSingleReceiverEvent = qrCodeData[7]
        
        
        print("theEventId \(theEventId)")
        print("theOwnerId \(theOwnerId)")
        print("theEventType \(theEventType)")
        
        
//        let theEventName: String = qrCodeData[0]
//                    let theEventDateTime: String = qrCodeData[1]
//        let theEventCode: String = qrCodeData[2]
//        let theEventImage: String = qrCodeData[3]
        
        if completionAction == "postloginscan" {
            //remove the HomeViewController from the Stack when Scanner is called
            navigationController!.removeViewController(HomeViewController.self)
            //RSVP
//            print("postLogin theEventId =\(theEventId)")
//            print("postLogin theOwner =\(theOwnerId ?? <#default value#>)")
//            if theEventCode != "" {
//                self.addToEvent(profileId: profileId, email: "", phone: "", eventCode: theEventCode, token: token, eventId: theEventId, ownerId: theOwnerId)
//
//
//            }
            addinvitees(myProfileId: profileId, firstName: firstname, lastName: lastname, email: email, phone: phone, eventId: theEventId, ownerProfileId: theOwnerId)
                
            //launch spray screen
                //launch admin payment if one doesn't exist
            
        } else {
            
            print("PRE LOGIN")
            print("pretLogin theEventId =\(theEventId)")
            print("pretLogin theEventId =\(theOwnerId)")
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginQRScanViewController") as! LoginQRScanViewController
    //
            nextVC.eventName =  theEventName
            nextVC.eventDateTime = theEventDateTime
            nextVC.eventCode = theEventCode
            nextVC.eventTypeIcon = theEventImage
            nextVC.eventId = theEventId
            nextVC.ownerId = theOwnerId
            nextVC.eventType = theEventType
            
            //nextVC.labelMessageInput = code
    //            nextVC.eventDateTime = eventDateTime
    //            nextVC.eventCode = eventCode
    //            nextVC.eventId = eventId
    //            nextVC.profileId = profileId
    //            nextVC.token = token
    //            nextVC.eventTypeIcon = eventTypeIcon
    //            nextVC.paymentClientToken = paymentClientToken
                       
            self.navigationController?.pushViewController(nextVC , animated: true)
        }
        
        func doStuff() {
            
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LoginQRScanViewController.self))
//        let nextVC =  storyboard.instantiateViewController(withIdentifier:"LoginQRScanViewController") as! LoginQRScanViewController
//        nextVC.eventName =  theEventName
//        nextVC.eventDateTime = theEventDateTime
//        nextVC.eventCode = theEventCode
//        nextVC.eventTypeIcon = theEventImage
//        let navigationController = UINavigationController(rootViewController: nextVC)
//        self.present(navigationController, animated: true, completion: nil)
//
//        dismiss(animated: true)
    }
}


//class EmptyHomeScreenViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    @IBAction func launchQRBarcodeScanner(_ sender: Any) {
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
