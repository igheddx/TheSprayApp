//
//  Spinner.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/28/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class Spinner {
   func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Processing...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();

    ProgressDialog.alert.view.addSubview(loadingIndicator)
    //present(ProgressDialog.alert, animated: true, completion: nil)
  }

  func LoadingStop(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}
