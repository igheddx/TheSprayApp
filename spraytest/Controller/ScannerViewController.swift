//
//  ScannerViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//


import UIKit
import AVFoundation
 
class ScannerViewController: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
        
//        let theEventName: String = qrCodeData[0]
//                    let theEventDateTime: String = qrCodeData[1]
//        let theEventCode: String = qrCodeData[2]
//        let theEventImage: String = qrCodeData[3]
        
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "JoinEventWithQRCodeViewController") as! JoinEventWithQRCodeViewController
                   
        nextVC.eventName =  theEventName
        nextVC.eventDate = theEventDateTime
        nextVC.eventCode = theEventCode
        nextVC.eventTypeIcon = theEventImage
        
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