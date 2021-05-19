//
//  EventSettingContainerViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 10/22/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit



class EventSettingContainerViewController: UIViewController{
       
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var token: String?
    var eventId: Int64?
    var profileId: Int64?
    var ownerId: Int64?
    var paymentClientToken: String?
    var paymentNickName: String?
    var isAttendingEventId: Int64?
    var eventTypeIcon: String = ""
    var screenIdentifier: String?
    var isRefreshData: Bool = false
    
    //var paymentOptionType: BTUIKPaymentOptionType?
    //var paymentMethodNonce: BTPaymentMethodNonce?
    var paymentDescription: String?
    var isReadyToSavePayment: Bool = false
    var eventSettingRefresh: Bool = false
    
    var refreshscreendelegate: RefreshScreenDelegate?
    var  testDelegate: GetClearEventDataDelegate?
    var selectionDelegate: SideSelectionDelegate!
    var encryptedAPIKey: String = ""
    
    //var sprayDelegate: SprayTransactionDelegate!
    //var selectionDelegate: SideSelectionDelegate!
    enum Segues {
        static let toNextVC =  "toEventSettingTableView"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("isRefreshData Container\(isRefreshData)")
    }
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        print("View Will Diappar")
           // When you want to send data back to the caller
           // call the method on the delegate
//        if let refreshscreendelegate = self.refreshscreendelegate {
//            refreshscreendelegate.refreshScreen2(isRefreshScreen: true)
//            print("ViewWill Disappear")
//           } else {
//             print("if let refreshscreendelegate is false" )
//           }

            // Don't forget to reset when view is being removed
            AppUtility.lockOrientation(.all)
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            debugPrint("Back Button pressed Home.")
            
            print("isRefreshData from container screen \(isRefreshData)")
            //selectionDelegate.didTapChoice(name: "Dominic")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshData)
            //sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toNextVC {
            let nextVC = segue.destination as! EventSettingTableViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDateTime = eventDateTime
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
            nextVC.isAttendingEventId = isAttendingEventId
            nextVC.screenIdentifier = screenIdentifier
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.getIsRefreshDataDelegate = self
            
        } else if segue.identifier == "backToHome" {
            print("backToHome Segue")
            let nextVC = segue.destination as! EventSettingContainerViewController
            nextVC.isRefreshData = isRefreshData
        
           
        } else if segue.identifier == "goToHomeScreen" {
            print("go to home backToHome Segue")
            let nextVC = segue.destination as! HomeViewController
            nextVC.isRefreshData = isRefreshData
            nextVC.profileId = profileId!
        }
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
extension EventSettingContainerViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
        print("refreshData function was called")
        isRefreshData = isRefreshScreen
    }
////    
////        func refreshScreen(isRefreshScreen: Bool) {
////
////       
////        
////            //print("refreshHomeScreenDate = \(isShowScreen)")
////        }
}
