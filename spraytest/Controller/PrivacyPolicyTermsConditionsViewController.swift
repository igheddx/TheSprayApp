//
//  PrivacyPolicyTermsConditionsViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/23/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import WebKit
class PrivacyPolicyTermsConditionsViewController: UIViewController, WKNavigationDelegate, WKUIDelegate  {

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DOMINIC AWELE")
        launchWebView()
        //webView?.navigationDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func launchWebView(){
        let url = URL(string: "https://www.privacypolicies.com/live/38d6aeee-249f-4194-9384-07e869d71395")!
        webView.load(URLRequest(url: url))
       // webView.allowsBackForwardNavigationGestures = true
//        let webView2 = WKWebView()
//        webView2.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
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

//extension StripeAccountOnboardingViewController: WKNavigationDelegate{
//
//}

