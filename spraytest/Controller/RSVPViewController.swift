//
//  RSVPViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/22/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class RSVPViewController: UIViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var yesRSVPbtn: RSVPYesBtn!
    //@IBOutlet weak var maybeRSVPbtn: MyCustomButton2!
    
    @IBOutlet weak var eventUIView: UIView!
    @IBOutlet weak var noRSVPbtn: RSVPNoBtn!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    var profileId: Int64 = 0
    var eventOwnerProfileId: Int64 = 0
    var eventId: Int64 = 0
    var token: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var paymentClientToken: String = ""
    var eventTypeIcon: String = ""
    var isPaymentMethodAvailable: Bool = false
    var isPaymentMethodAvailableEvent: Int = 0
    var refreshscreendelegate: RefreshScreenDelegate?
    var setRefreshScreen: Bool = false
    var encryptedAPIKey: String = ""
    //let isPaymentMethodAvailable: Bool = UserDefaults.standard.bool(forKey: "isPaymentMethodAvailable")
    var myProfileData: [MyProfile] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        yesRSVPbtn.setTitleColor(UIColor.black, for: .normal)
        noRSVPbtn.setTitleColor(UIColor.black, for: .normal)
        // Do any additional setup after loading the view.
        updateEventInfo()
        
        self.navigationItem.title = "RSVP"
       
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    func updateEventInfo(){
        eventNameLbl.text = eventName
        eventDateTimeLbl.text = eventDateTime
        eventImage.image = UIImage(named: eventTypeIcon)
    }
    @IBAction func yesRSVPBtnPressed(_ sender: Any) {
//        yesRSVPbtn.setTitleColor(UIColor.white, for: .normal)
//        //layer.cornerRadius = 6
//        //backgroundColor = UIColor.red
//        yesRSVPbtn.layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        //layer.borderWidth = 1
        yesRSVPbtn.backgroundColor = UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0)
//        yesRSVPbtn.layer.cornerRadius = 4
//        yesRSVPbtn.layer.shadowColor = UIColor.white.cgColor
//        yesRSVPbtn.layer.shadowOffset = CGSize(width: 2, height: 2)
//        yesRSVPbtn.layer.shadowRadius = 5
//        yesRSVPbtn.layer.shadowOpacity = 0.5
//        yesRSVPbtn.layer.masksToBounds = true
        
        //confirm RSVP
        rsvp()
        createParticles()
        setRefreshScreen = true
        
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            debugPrint("Back Button pressed Home - from RSVPViewe Controller.")
            
            //print("isRefreshData from container screen \(isRefreshData)")
            //selectionDelegate.didTapChoice(name: "Dominic")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: setRefreshScreen)
            //refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshData)
            //sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)

        }
    }
    @IBAction func noRSVPBtnPressed(_ sender: Any) {
        noRSVPbtn.backgroundColor =  UIColor(red: 178/256, green: 9/256, blue: 18/256, alpha: 1.0)
        setRefreshScreen = true
    }
    
    
    func rsvp() {
        
       
        var firstname: String = ""
        var lastname: String = ""
        var email: String = ""
        var phone: String = ""
        for profile in myProfileData {
            firstname = profile.firstName
            lastname = profile.lastName
            email = profile.email
            phone = profile.phone
        }
       
        let addAttendee = AddAttendees(profileId: eventOwnerProfileId, eventId: eventId, eventAttendees: [Attendees(profileId: profileId, firstName: firstname, lastName: lastname, email: email, phone: phone, eventId: eventId, isAttending: true)])
        //let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
        
        print("RSVP addAttendee = \(addAttendee)")
        //print(updateAttendee)
        //isRefreshScreen = true
        let request = PostRequest(path: "/api/Event/addattendees", model: addAttendee, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Empty, Error>)  in
                    switch result {
                    case .success( _):
                        if self.isPaymentMethodAvailable == false && isPaymentMethodAvailableEvent == 0 {
                            self.transitionAlertView(completionAction: "addpaymentalert")
                            setRefreshScreen = true
                        }
                        
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

    func transitionAlertView(completionAction: String) {
        var alertmessage: String = ""
        var completionAction2: String = ""
        if completionAction == "addpaymentalert" {
            alertmessage = "Congratulations! We are glad you are coming to the event. There are no Payment Method on record. Would you like to Add a Payment Method for this Event?"
            completionAction2 = "launchpaymentscreen"
        } else {
            alertmessage = "Congratulations! Are you ready to start  Spraying?"
            completionAction2 = "launchsprayscreen"
        }
        let alert = UIAlertController(title: "Congratulations", message: alertmessage, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in self.gotoSprayScreen(completionAction: completionAction2)}))
        //alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action) in self.gotoHomeScreen()}))
        self.present(alert, animated: true)
    }
    
    func gotoSprayScreen(completionAction:String) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "GoSprayViewController") as! GoSprayViewController

        nextVC.eventId = eventId
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.completionAction = completionAction
        nextVC.paymentClientToken = paymentClientToken

        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    func gotoEventPaymentScreen() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventPaymentViewController") as! EventPaymentViewController
        
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventId = eventId
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.paymentClientToken  =  paymentClientToken
        
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func gotoHomeScreen() {
        setRefreshScreen = true
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.myProfileData = myProfileData
        nextVC.paymentClientToken =  paymentClientToken
        
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)

        particleEmitter.emitterCells = [red, green, blue]

        view.layer.addSublayer(particleEmitter)
    }

    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage(named: "confetti1")?.cgImage
        return cell
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
