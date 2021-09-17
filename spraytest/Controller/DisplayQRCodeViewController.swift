//
//  DisplayQRCodeViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/9/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

//let frame = CGRect(origin: .zero, size: .init(width: 320, height: 320))
//let view = DisplayQRCodeViewController(frame: frame)


class DisplayQRCodeViewController: UIViewController {
    var eventId: Int64 = 0
    var profileId: Int64 = 0
    var token: String?
    var eventName: String = ""
    var eventCode: String = ""
    var eventDate: String = ""
    var eventType: String =  ""
    var eventTypeIcon: String = ""
    var paymentClientToken: String?
    var ownerId: Int64 = 0
    var urlAppStore: String = ""
    var urlBackToApp: String = ""
    var isSingleReceiverEvent: Bool = true
    var encryptedAPIKey: String = ""
    var country: String = ""
    
    @IBOutlet weak var eventUIView: EventUIView!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    @IBOutlet weak var eventImage: CircularImage!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    
    
    lazy var filter = CIFilter(name: "CIQRCodeGenerator")
    lazy var imageView = UIImageView()

  
//    override init(frame: CGRect) {
//      super.init(frame: frame)
//      addSubview(imageView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//    }

//    override func layoutSubviews() {
//      super.layoutSubviews()
//      imageView.frame = bounds
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Event QR Code"
       
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        print("profileId = \(profileId)")
        print("ownerId = \(ownerId)")
        print("eventId = \(eventId)")
        
        
        eventNameLbl.text = eventName
        eventDateTimeLbl.text = eventDate
        eventImage.image = UIImage(named: eventTypeIcon)
        
        print("eventname \(eventName)")
        //change single receiver value to string
        var isSingleReceiverEventStr: String = ""
        if isSingleReceiverEvent == true {
            isSingleReceiverEventStr = "true"
        } else  {
            isSingleReceiverEventStr = "false"
        }
       let newName = eventName.replacingOccurrences(of: "’", with: "&apos;")
        
        print("NEW eventname \( newName)")
        let qrData = "\(newName )| \(eventDate)| \(eventCode)| \(eventTypeIcon)| \(eventId)| \(ownerId)| \(eventType)| \(isSingleReceiverEventStr)| \(country)"
        print(qrData)
      generateCode(qrData,foregroundColor: UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),backgroundColor: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00))

        //generateQRCode()
        // Do any additional setup after loading the view.
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
      guard let filter = filter,
        let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
        return
      }

      filter.setValue(data, forKey: "inputMessage")

      guard let ciImage = filter.outputImage else {
        return
      }

      let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
      let invertFilter = CIFilter(name: "CIColorInvert")
      invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

      let alphaFilter = CIFilter(name: "CIMaskToAlpha")
      alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)

      if let outputImage = alphaFilter?.outputImage  {
        
        QRCodeImage.tintColor = foregroundColor
        QRCodeImage.backgroundColor = backgroundColor
        QRCodeImage.image = UIImage(ciImage: outputImage, scale: 2.0, orientation: .up)
          .withRenderingMode(.alwaysTemplate)
      }
    }
    func generateQRCode1(){
        
        var inputstring = "?cht=qr&chs=300x300&chl=DominicI ighedosa"
        //https://chart.googleapis.com/chart?cht=qr&chs=300x300&chl=[1/1/2020, DominicI ighedosa, ABCD]
        
        var queryCharSet = NSCharacterSet.urlQueryAllowed
        queryCharSet.remove(charactersIn: "+&?,:;@+=$*()")
            
        let utfedCharacterSet = String(utf8String: inputstring.cString(using: .utf8)!)!
        let encodedStr = utfedCharacterSet.addingPercentEncoding(withAllowedCharacters: queryCharSet)!
            
        //let paramUrl = "https://api.abc.eu/api/search?device=true&query=\(encodedStr)"
        
        let request = RequestQR(path: "chart\(inputstring )", token: "")
        
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let qrcode):
      
                self.QRCodeImage.image = UIImage(named: qrcode.description)
            
            case .failure(let error):
                print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
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
