//
//  TestViewController2.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/24/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class TestViewController2: UIViewController {

    @IBOutlet weak var myimage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets navigationBar's background to a blank/empty image
       
        
//        view.isOpaque = false
//           view.backgroundColor = .clear // try other colors, say: .white or black with Alpha etc.
//
//        UINavigationBar.appearance().setBackgroundImage(UIImage(),
//                                                        for: .default)
//
//        // Sets shadow (line below the bar) to a blank image
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().isTranslucent = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let navigationBar = self.navigationController?.navigationBar

        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let navigationBar = self.navigationController?.navigationBar

        navigationBar?.shadowImage = nil
        navigationBar?.setBackgroundImage(nil, for: .default)
        navigationBar?.isTranslucent = false
    }

    

    override var prefersStatusBarHidden: Bool {
        return true
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
