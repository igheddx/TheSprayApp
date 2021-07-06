//
//  EmptyHomeScreenViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/7/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation
import JJFloatingActionButton



class EmptyHomeScreenViewController: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    var encryptedAPIKey: String = ""
 
    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myImageView.image = imageWith(name: "Dominic Ighedoa")
        myImageView.layer.borderWidth = 1
        myImageView.layer.masksToBounds = false
        myImageView.layer.borderColor = UIColor.black.cgColor
        myImageView.layer.cornerRadius = myImageView.frame.height/2
        myImageView.clipsToBounds = true
      // frame.height/2
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100)))
        
        if let apiKey = Bundle.main.infoDictionary?["KEY256"] as? String {
            label.backgroundColor = .red
            label.text = apiKey
        }
        view.addSubview(label)
        
        let actionButton = JJFloatingActionButton()
        let actionButton2 = JJFloatingActionButton()
        
        actionButton2.circleView.color = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
        actionButton.circleView.color = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
        
//        actionButton.addItem(title: "item 1", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//        }
//
//        actionButton.addItem(title: "item 2", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//        }

//        actionButton.addItem(title: "item 3", image: nil) { item in
//          // do something
//        }
//
//        actionButton2.addItem(title: "item 3", image: nil) { item in
//          // do something
//        }
        
        actionButton2.addItem(title: "", image: UIImage(systemName: "house.fill")) { item in
            //print("itme 3 was selected")
            //self.launchSprayCandidate()
        }
        actionButton.addItem(title: "", image: UIImage(systemName: "person.2.fill")) { item in
            //print("itme 3 was selected")
           // self.launchSprayCandidate()
        }
        
        //actionButton.buttonAnimationConfiguration.opening.duration = 0.3
        
//        actionButton.buttonAnimationConfiguration.opening.duration = 0.3
//        actionButton.buttonAnimationConfiguration.opening.dampingRatio = 0.55
//        actionButton.buttonAnimationConfiguration.opening.initialVelocity = 0.3
//
        
        
        let me = actionButton.buttonState
        print("me = \(me)")
        
       // actionButton.buttonDiameter(actionButton)
        actionButton.buttonDiameter = 45
        actionButton.buttonImageSize = CGSize(width: 25, height: 25)
        actionButton2.buttonDiameter = 45
        actionButton2.buttonImageSize = CGSize(width: 25, height: 25)
        
        view.addSubview(actionButton)
        view.addSubview(actionButton2)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        
        actionButton2.translatesAutoresizingMaskIntoConstraints = false
        actionButton2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true

        
        
        //actionButton.sendActions(for: .touchUpInside)
        
    }
    
    func imageWith(name: String?) -> UIImage? {
           let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
           let nameLabel = UILabel(frame: frame)
        nameLabel.layer.cornerRadius = nameLabel.frame.height/2
           nameLabel.textAlignment = .center
           nameLabel.backgroundColor = .lightGray
           nameLabel.textColor = .white
           nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
           var initials = ""
           if let initialsArray = name?.components(separatedBy: " ") {
               if let firstWord = initialsArray.first {
                   if let firstLetter = firstWord.first {
                       initials += String(firstLetter).capitalized }
               }
               if initialsArray.count > 1, let lastWord = initialsArray.last {
                   if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                   }
               }
           } else {
               return nil
           }
           nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
           if let currentContext = UIGraphicsGetCurrentContext() {
               nameLabel.layer.render(in: currentContext)
               let nameImage = UIGraphicsGetImageFromCurrentImageContext()
               return nameImage
           }
           return nil
       }
    @IBAction func openScanner(_ sender: Any) {
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
extension EmptyHomeScreenViewController : AVCaptureMetadataOutputObjectsDelegate {
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
    }
}


extension EmptyHomeScreenViewController: JJFloatingActionButtonDelegate {
  
        func floatingActionButtonWillOpen(_ button: JJFloatingActionButton) {
            
        }
        func floatingActionButtonDidOpen(_ button: JJFloatingActionButton) {
            print("floatingActionButtonDidOpen")
        }
        func floatingActionButtonWillClose(_ button: JJFloatingActionButton) {
            
        }
        func floatingActionButtonDidClose(_ button: JJFloatingActionButton) {
            
        }
}

//class InitialsImageFactory: NSObject {
//class func imageWith(name: String?) -> UIImage? {
//
//let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//let nameLabel = UILabel(frame: frame)
//nameLabel.textAlignment = .center
//nameLabel.backgroundColor = .lightGray
//nameLabel.textColor = .white
//nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
//var initials = ""
//
//if let initialsArray = name?.components(separatedBy: " ") {
//
//  if let firstWord = initialsArray.first {
//    if let firstLetter = firstWord.characters.first {
//      initials += String(firstLetter).capitalized
//    }
//
//  }
//  if initialsArray.count > 1, let lastWord = initialsArray.last {
//    if let lastLetter = lastWord.characters.first {
//      initials += String(lastLetter).capitalized
//    }
//
//  }
//} else {
//  return nil
//}
//
//nameLabel.text = initials
//UIGraphicsBeginImageContext(frame.size)
//if let currentContext = UIGraphicsGetCurrentContext() {
//  nameLabel.layer.render(in: currentContext)
//  let nameImage = UIGraphicsGetImageFromCurrentImageContext()
//  return nameImage
//}
//return nil
//}
//}
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
