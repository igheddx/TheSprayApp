//
//  QRScanner2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 7/11/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation
class QRScanner2ViewController: UIViewController, UINavigationBarDelegate,  UITabBarControllerDelegate {
    
    var counter: Int = 0
    var completionAction: String = ""
    var completionAction2: String = ""
    
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
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
          AVMetadataObject.ObjectType.code39,
          AVMetadataObject.ObjectType.code39Mod43,
          AVMetadataObject.ObjectType.code93,
          AVMetadataObject.ObjectType.code128,
          AVMetadataObject.ObjectType.ean8,
          AVMetadataObject.ObjectType.ean13,
          AVMetadataObject.ObjectType.aztec,
          AVMetadataObject.ObjectType.pdf417,
          AVMetadataObject.ObjectType.itf14,
          AVMetadataObject.ObjectType.dataMatrix,
          AVMetadataObject.ObjectType.interleaved2of5,
          AVMetadataObject.ObjectType.qr]
        
        @IBOutlet var messageLabel: UILabel!
        @IBOutlet var topBar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAvailablePaymentData()
        print("BRIAN TAB ID VIEW DID LOAD = \(tabBarController!.selectedIndex )")
        //print("completeion action ====== \(completionAction)")
            //tabBarController?.delegate = self
        navigationController!.removeViewController(HomeViewController.self)
        
        //addNavigationBar()
        
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
        
        var i: Int = 0
        self.navigationController?.navigationBar.topItem?.title = "Scan QR Code"
        //self.navigationController?.navigationBar.backgroundColor = .red
        //setNavigationBar()
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            i = i + 1
            print("I CALLED CAPTURE - \(i)")
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubviewToFront(messageLabel)
            //view.bringSubviewToFront(topBar)// comment out for now
            
            // Initialize QR Code Frame to highlight the QR Code
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
    }

 
    func addNavigationBar() {
         let height: CGFloat = 40
         var statusBarHeight: CGFloat = 0
         if #available(iOS 13.0, *) {
             statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
             print("A")
         } else {
             statusBarHeight = UIApplication.shared.statusBarFrame.height
             print("B")
         }
         let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
         navbar.backgroundColor = UIColor.white
         navbar.delegate = self as? UINavigationBarDelegate

         let navItem = UINavigationItem()
         navItem.title = "Sensor Data"
         navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissViewController))

         navbar.items = [navItem]

         view.addSubview(navbar)

         self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
     }

     @objc func dismissViewController() {
         
     }
  
   /* func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // im my example the desired view controller is the second one
            // it might be different in your case...
        print("TAB BAR NAYLA")
            let secondVC = tabBarController.viewControllers?[1] as! UINavigationController
            secondVC.popToRootViewController(animated: false)
        
        
        
    }*/
    
    /*func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
     // im my example the desired view controller is the second one
     // it might be different in your case...
        print("TAB BAR NAYLA")
     let secondVC = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
     secondVC.popToRootViewController(animated: false)
    
    }*/
    
    // UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("Selected item")
    }

    // UITabBarControllerDelegate
    private func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBar()
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
        
        print("view is disappering and removing vc")
//        self.dismiss(animated: true, completion: {
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
//        })
        
        //remove scanner VC from the stack when going back to home VC
        //navigationController!.removeViewController(ScannerViewController.self)
        //navigationController!.removeViewController(QRScanner2ViewController.self)
        //navigationController!.removeViewController(MainNavigationViewController.self)
        
        //navigationController!.removeViewController(DashboardNavigationViewController.self)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setstatusbarbgcolor.setBackground()
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    func getAvailablePaymentData() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let paymentmethod1):
               //self.parse(json: event)
            print("it's successful")
            let decoder = JSONDecoder()
                do {
                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                    /*if no payment record on file then use default country region code to get
                    currencyCode */
                    if paymentJson.count == 0 {
                        isPaymentMethodAvailable = false
                        completionAction2 = "addpayment"
                    } else {
                        for paymenttypedata in paymentJson {
                            print("first time in the loop")
                            if paymenttypedata.customName != "" {
                                /*assign currency, */
                                if paymenttypedata.defaultPaymentMethod == true {
                                    isPaymentMethodAvailable = true
                                    completionAction2 = "selecpayment"
                                }
                            }
                        }
                    }
                    print("success but no data")
                 } catch {
                    print(error)
                 }
            
                case .failure(let error):
                   print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
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
        country = qrCodeData[8]
        
        
        
        print("theEventId \(theEventId)")
        print("theOwnerId \(theOwnerId)")
        print("theEventType \(theEventType)")
        
        print("completionAction = \(completionAction)")
        
//        let theEventName: String = qrCodeData[0]
//                    let theEventDateTime: String = qrCodeData[1]
//        let theEventCode: String = qrCodeData[2]
//        let theEventImage: String = qrCodeData[3]
        
        if completionAction == "postloginscan" {
            //remove the HomeViewController from the Stack when Scanner is called
            //navigationController!.removeViewController(HomeViewController.self)
            
            print(" I AM INSIDE POSTLOGINSCAN  ")
            
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
        
    }
    
    func addinvitees(myProfileId: Int64, firstName: String, lastName: String, email: String, phone: String, eventId: Int64, ownerProfileId: Int64) {
        
    
        let addInvitees = AddInvitee(profileId: ownerProfileId, eventId: eventId, eventInvitees: [AddInvitee2(firstName: firstName, lastName: lastName, email: email, phone: phone, profileId: myProfileId)])
            // JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
        
        print("token = \(token)")
        print("addInvitees= \(addInvitees)")
        
        let request = PostRequest(path: "/api/Event/addinvitees", model: addInvitees, token: token, apiKey: encryptedAPIKey, deviceId: "")
        
        
        print("addinvitees request = \(request)")
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
                print("Add To event was successful")
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
                        print("launchVC() was called")
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
        print("launchVC() home")
      
        //navigationController!.removeViewController(QRScanner2ViewController.self)
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "GoSprayViewController") as! GoSprayViewController
        //MenuTabViewController
        
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.completionAction = completionAction
        nextVC.country = country
        nextVC.isPaymentMethodAvailable = isPaymentMethodAvailable
        nextVC.completionAction = completionAction2
//        nextVC.eventType =  theEventType
//        nextVC.eventOwnerId = theOwnerId
//        nextVC.myProfileData = myProfileData
//        nextVC.isRefreshData = true
//        nextVC.QRCodeScan = "I CAME FROM QRSCANNER"
//        
        nextVC.eventOwnerProfileId = theOwnerId
        
       self.navigationController?.pushViewController(nextVC , animated: true)
        dismiss(animated: true, completion: nil)
        
       // navigationController!.removeViewController(QRScanner2ViewController.self)
        
    }
    
    func setNavigationBar() {
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        
        //self.navigationController?.navigationBar.topItem?.title = "Your Title"

     
        
        //let NavTitle = navBar.topItem?.title = "Scan"
        
        //self.navigationController?.navigationBar.topItem?.title = "Scan"
        navItem.title = "Scan QR Code"
        //let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
          // navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
           self.view.addSubview(navBar)
    }
    
    //returns user to login when back button is pressed
    @objc func done() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav

       self.navigationController?.popToRootViewController(animated: true)
    }
    
}

    extension QRScanner2ViewController: AVCaptureMetadataOutputObjectsDelegate {
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObjects array is not nil and it contains at least one object
            if metadataObjects.count == 0 {
                qrCodeFrameView?.frame = CGRect.zero
                messageLabel.text = "No QR code is detected"
                return
            }
            
            // Get the metadata object
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if supportedCodeTypes.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                
                if metadataObj.stringValue != nil {
                    messageLabel.text = metadataObj.stringValue
                    print("metadataObj.stringValue = \(metadataObj.stringValue)")
                    counter = counter + 1
                    if counter == 1 {
                        found(code: metadataObj.stringValue!)
                        metadataObj.stringValue
                        captureSession.stopRunning()
                    } else {
                        counter = 0
                    }
                    print("I CALLED FOUND - \(counter)")
                    
                }
            }
        }
    }


extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
