//
//  StripeAccountOnboardingViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 3/5/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import WebKit
class StripeAccountOnboardingViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    
    @IBOutlet weak var testlbl: UILabel!
    
    var textforlbl: String = ""
    var urlRedirect: String = ""
    var profileId: Int64 = 0
    var token: String = ""
    var myProfileData: [MyProfile] = []
    var paymentClientToken: String = ""
    
    var webViewObserver: NSKeyValueObservation?
    var refreshscreendelegate: RefreshScreenDelegate?
    var setRefreshScreen: Bool = false
    var encryptedAPIKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        webView?.navigationDelegate = self
        //webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        /* comment this out for now 1/17*/
         
         self.navigationItem.title = "Verify Self"
       
        navigationItem.hidesBackButton = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
       
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //print("urlRedirect =\(urlRedirect)")
//        let myURL = URL(string: urlRedirect!)
//        guard let name = element.urlRedirect! as? String else {
//            print("something went wrong, element.Name can not be cast to String")
//            return
//        }
        launchWebView(urlString: String(urlRedirect))
        //urlRedirect.description
        //if let url = URL(string: urlRedirect) {
              //let request = URLRequest(url: urlRedirect!)
            //webView.load(request)
           // print("load web view")
        //getJSON(strURL:urlRedirect)
          //} else {
            //print("don't load")
      // Do something like. Show an alert that could not load webpage etc.
      //}
//        guard let urlString = urlRedirect, // forced unwrapped
//                let url = URL(string: urlString)
//               else {  return }  // if there is any optional we return
//        // else continue
//               let request: URLRequest = URLRequest(url: url)
//               webView.load(request)
//
//        var url: URL?
//        url = URL(string: "\(urlRedirect)")
//        print("my url = \(url!)")
//        let request = URLRequest(url: URL(string: urlRedirect) ?? urlRedirect)
//        webView?.load(request)
//        print("loading browser")
        
        
        //var myURL: String = ""
        
//        var url = "" {
//            didSet {
//               //trigger your webView to start loading, you can also do it at viewDidAppear maybe.
//               //example:
//               let url = URL(string: url)
//               let request = URLRequest(url: url)
//               webView.loadRequest(request)
//            }
//        }
        
//        let urlWithPath = url.flatMap { URL(string: $0.absoluteString ) }
//        print("urlWithPath \(urlWithPath!)")
//        let myRequest = URLRequest(url: urlWithPath!)
//        //webView.delegate = self
//        webView?.load(myRequest)
        
//        if let url2 = urlWithPath  {
//        //guard let url = URL(string: "https://projectxapiapp.azurewebsites.net")?.appendingPathComponent(path) else {
//            print("url2 = \(url2)")
//            let myRequest = URLRequest(url: url2)
//            webView.load(myRequest)
//
////            Log.assertFailure("Failed to create base url")
////            return URLRequest(url: URL(fileURLWithPath: ""))
//        } else {
//            print("do nothing")
//        }

//        if let myUrl = URL(string: urlRedirect) {
//            //myURL = url
//            //UIApplication.shared.openURL(url)
//            print("myURL = \(myUrl)")
//            let myRequest = URLRequest(url: myUrl)
//            webView.load(myRequest)
//        } else {
//            print("do nothing")
//        }
//
       
        
        // Do any additional setup after loading the view.
        
        //testlbl?.text = textforlbl
    }
//    override func viewDidAppear(_ animated: Bool) {
//       // launchWebView(urlString: urlRedirect)
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webViewObserver?.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        refreshscreendelegate?.refreshScreen(isRefreshScreen: setRefreshScreen)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            debugPrint("Back Button pressed Home.")
            
            //print("isRefreshData from container screen \(isRefreshData)")
            //selectionDelegate.didTapChoice(name: "Dominic")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: setRefreshScreen)
            
            //refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshData)
            //sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)
         
        }
    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            print(Float(webView.estimatedProgress))
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
        webView = WKWebView(frame: self.view.bounds)
        webViewObserver = webView?.observe(\.url, options: .new, changeHandler: {
            (currentWebView, _) in
            //      Here you go the new path
            currentWebView.url
            print("got the new path \(currentWebView.url)")
        })
    }
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
//            let urlString = navigationAction.sourceFrame.request.url?.absoluteString ?? ""
//            print("\(urlString)")
//            decisionHandler(.allow)
//     }
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        if let url = webView.url?.absoluteString{
//            print("url I Karl's redirect = \(url)")
//        }
//    }
    func launchWebView(urlString: String){
        print("inside launch webview \(urlString)")
        let cleanStr =  urlString.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
        print("cleanStr \(cleanStr)")
        let stripURL = String(cleanStr) //"https://connect.stripe.com/setup/s/rj3P9V1UW0Ns"
        let index = stripURL.lastIndex(of: "/") ?? stripURL.endIndex
        let indexNoSpace = stripURL.index(after: index)
        let range = indexNoSpace..<stripURL.endIndex

        let stripeURLToken = stripURL[range]
        print(stripeURLToken)
        
        
        //let myurl2 = "UpBDYlP4NCpU"
        let stripeUrlLaunchWebView = cleanStr //"https://connect.stripe.com/setup/s/\(stripeURLToken)"
        let url = URL(string: stripeUrlLaunchWebView)!
        //if let unwrappedURL = url {
            let request = URLRequest(url: url)
            webView?.load(request)
            print("loading browser")
        //}
        /*set the isRefreshHomeVC variable to force a refresh when user returns to the home screen*/
        defaults.set(true, forKey: "isRefreshHomeVC")
    }
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
       webView = WKWebView(frame: .zero, configuration: webConfiguration)
       webView.uiDelegate = self
       view = webView
    }

    func getJSON(strURL: String)  {
        if let encoded = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let myURL = URL(string: encoded) {
           print("myURL \(myURL)")
        }

        var dictReturn:Dictionary<String, Any> = [:]

        //cancel data task if it is running
        //myDataTask?.cancel()
    }
    
  

    func launchHomeVC(onboardingStatus: String, profileId: String) {
        //setRefreshScreen = true
        setRefreshScreen = true
        //refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        nextVC.profileId = Int64(profileId)!
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.myProfileData = myProfileData
        nextVC.paymentClientToken =  paymentClientToken
        nextVC.isRefreshData = true
        
        self.navigationController?.pushViewController(nextVC , animated: true)
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


// Deep Link
extension StripeAccountOnboardingViewController {
    func handleDeepLink(_ deepLink: String) {
        switch deepLink {
        case "onboardingok":
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingOKViewController") as! StripeOnboardingOKViewController
            nextVC.lbldesc = "my onboarding is very very ok"

            self.navigationController?.pushViewController(nextVC , animated: true)
        case "onboardingnotok":
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingNotOKViewController") as! StripeOnboardingNotOKViewController
            self.navigationController?.pushViewController(nextVC , animated: true)
        default:
            print("do nothing")
        }
    }
}

//extension StripeAccountOnboardingViewController: MyDeepLink {
//    func deepLink(deeplink: DeepLink) {
//        <#code#>
//    }
//
//    func deepLink(deeplink: String) {
//        print("deepLink was called = \(deeplink)")
//        switch deeplink {
//        case "onboardingok":
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingOKViewController") as! StripeOnboardingOKViewController
//
//
//            self.navigationController?.pushViewController(nextVC , animated: true)
//        case "onboardingnotok":
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingNotOKViewController") as! StripeOnboardingNotOKViewController
//
//        default:
//            print("do nothing")
//        }
//    }
//
//
//}
extension URL {
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }
}

//var unwrappedURL = URL("https://www.avanderlee.com")
extension StripeAccountOnboardingViewController: WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("page finished load")
        print("page finish load \(navigation.description)")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        let currentURL : NSString = (webView.url!.host)! as NSString
       //print("The current String is\(currentURL)")
        if currentURL.contains("test.com")
       {
      //handle your actions here
       }
       print("finish to load --- \(currentURL)")
      }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation: \(navigation.debugDescription) DOMINIC")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        print(" awele \(navigation)")
    }
    
  
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(" DOMINIC IGHEDOSA IS HOST NAME \(navigationAction.request.url?.absoluteURL.host)")
        
        print(" DOMINIC IGHEDOSA IS  FULL URL \(navigationAction.request.url)")
        
        let urlHostname = navigationAction.request.url?.absoluteURL.host
        //let urlStr1 = navigationAction.request.url?.absoluteString
        //print(urlStr1.host)
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlHostname == "projectxclientapp.azurewebsites.net" {
                //let urlString = navigationAction.request.url?.absoluteURL
                //let urlStr = String(urlString) //"https://connect.stripe.com/setup/s/rj3P9V1UW0Ns"
                let index = urlStr.lastIndex(of: "?") ?? urlStr.endIndex
                let indexNoSpace = urlStr.index(after: index)
                let range = indexNoSpace..<urlStr.endIndex

                let newURL = urlStr[range]
               // print(newURL)

                let queryItems = URLComponents(string: "https://sprayapp.com/?\(newURL)")?.queryItems
                
                print("queryItems \(queryItems)")
                //print("queryItems \(queryItems)")
                let profileid = queryItems?.filter({$0.name == "profileid"}).first
                let status = queryItems?.filter({$0.name == "status"}).first
                let  token = queryItems?.filter({$0.name == "token"}).first
                //let token = queryItems?.filter({$0.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) == "token"}).first

                print(profileid?.value)

                print(status?.value)
                print(token?.value)

                //if status == "complete" {
                if status?.value == "success" {
                    launchHomeVC(onboardingStatus: (status?.value)!, profileId: (profileid?.value)!)
                }
            }

//
         }
//
      

       
        
        
       
        
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print("DOMINIC = \(url)")
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
