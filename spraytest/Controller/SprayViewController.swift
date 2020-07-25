//
//  SprayViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/16/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation
class SprayViewController: UIViewController {

    var swipeCount = 0
    var imgCount = 0
    var currencySymbol: String = "$"
    var sprayAmount = 0
    var player: AVAudioPlayer!
    var startingBalance: Int = 10
    var currencyDenomination: Int = 1
   
    var incomingGiftReceiverName: String!
    var gifterBalance: Int = 0
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var giftReceiverName: UILabel!
    @IBOutlet weak var giftAmountReceived: UILabel!
    @IBOutlet weak var gifterStartingBalance: UILabel!
    
    @IBOutlet weak var currencyDenomLabel: UILabel!
    
    override func viewDidLoad() {

                super.viewDidLoad()
                currencyDenomLabel.text = String(currencyDenomination)
                giftReceiverName.text = incomingGiftReceiverName
                giftAmountReceived.text = String("$\(sprayAmount)")
                
                if gifterBalance == 0 {
                    gifterStartingBalance.text = String(startingBalance)
                } else {
                    gifterStartingBalance.text = String(gifterBalance)
                }
                
                // Do any additional setup after loading the view.
                
                
                imgImage.isUserInteractionEnabled = true
                
                let swiftRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
                swiftRight.direction = UISwipeGestureRecognizer.Direction.right
                imgImage.addGestureRecognizer(swiftRight)
                
                let swiftLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
                swiftLeft.direction = UISwipeGestureRecognizer.Direction.left
                imgImage.addGestureRecognizer(swiftLeft)
                
                let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
                swiftUp.direction = UISwipeGestureRecognizer.Direction.up
                imgImage.addGestureRecognizer(swiftUp)
                
                let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
                swiftDown.direction = UISwipeGestureRecognizer.Direction.down
                imgImage.addGestureRecognizer(swiftDown)
                
            }
            
            func playSound() {
                let url = Bundle.main.url(forResource: "cashRegisterSound", withExtension: "mp3")
                player = try! AVAudioPlayer(contentsOf: url!)
                player.play()
            }
            
            @objc func swipeGesture(sendr: UISwipeGestureRecognizer) {
                let currencyArray = [#imageLiteral(resourceName: "currencySide2B"),#imageLiteral(resourceName: "currencySide1B"),#imageLiteral(resourceName: "currencySide3B")]
                //            if let swipeGesture = sendr as? UISwipeGestureRecognizer {
                //                switch swipeGesture.direction {
                //                case UISwipeGestureRecognizer.Direction.up:
                //                    print("swipe right")
                //                    //currencyImage = UIImage[0]
                //
                //                    sprayAmount += 1
                //
                //                    if swipeCount == 0 {
                //                        imgImage.image = currencyArray[swipeCount]
                //                        playSound()
                //                        swipeCount += 1
                //                        print(swipeCount)
                //                    } else if swipeCount == 1 {
                //                        imgImage.image = currencyArray[swipeCount]
                //                         playSound()
                //                        swipeCount = 0
                //                         print(swipeCount)
                //                    }
                //                default:
                
                //
                if let swipeGesture = sendr as? UISwipeGestureRecognizer {
                    switch swipeGesture.direction {
                        //case UISwipeGestureRecognizer.Direction.right:
                        // print("swipe right")
                        //swipeCount += 1
                        //imgImage.image = UIImage(named: "currency2")
                        //case UISwipeGestureRecognizer.Direction.left:
                        //print("swipe left")
                        //swipeCount += 1
                    //imgImage.image = UIImage(named: "currency")
                    case UISwipeGestureRecognizer.Direction.up:
                        
                        if gifterBalance == 0 {
                            imgImage.image  = currencyArray[2]
                            let alert = UIAlertController(title: "Out of funds!", message: "Would you like to replenish your funds so that you can continue with gifting? Select Yes to conitnue or No to return to the Home screen", preferredStyle: .actionSheet)

                            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                            self.present(alert, animated: true)
                            print("Balance is Zero")
                        } else  {
                            
                     
                        if swipeCount == 0  {
                            playSound()
                            imgImage.image  = currencyArray[swipeCount]
                            
                            print("swipe up \(swipeCount)")
                            swipeCount += 1
                            sprayAmount += 1
                            giftAmountReceived.text = String("$\(sprayAmount)")
                            
                            if gifterBalance >= 1 {
                                gifterBalance = gifterBalance  - currencyDenomination
                                gifterStartingBalance.text =  String("$\(gifterBalance)")
                            } else {
                                gifterBalance = startingBalance - currencyDenomination
                                gifterStartingBalance.text =  String("$\(gifterBalance)")
                            }
                            
                            print("gifterBalance under  IF  = \(gifterBalance)")
                            
                        } else if swipeCount == 1 {
                            
                            playSound()
                            imgImage.image  = currencyArray[swipeCount]
                            print("swipe up \(swipeCount)")
                            swipeCount = 0
                            sprayAmount += 1
                            giftAmountReceived.text = String("$\(sprayAmount)")
                            if gifterBalance >= 1 {
                                gifterBalance = gifterBalance  - currencyDenomination
                                gifterStartingBalance.text =  String("$\(gifterBalance)")
                            } else {
                                gifterBalance = startingBalance - currencyDenomination
                                gifterStartingBalance.text =  String("$\(gifterBalance)")
                            }
                            
                            print("gifterBalance under ELSE IF = \(gifterBalance)")
                        }
                        
                              }
                        //imgImage.image = UIImage(named: "currency2")
                        //                case UISwipeGestureRecognizer.Direction.up:
                        //                     playSound()
                        //                    swipeCount += 1
                        //                    print("swipe up 2 \(swipeCount)")
                    //imgImage.image = UIImage(named: "currency2")
                    default:
                        break
                       
                                     
                        
                    }
                        
                       
                    //messageSwipeCount.text = String ("\(currencySymbol) \(sprayAmount)")
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
