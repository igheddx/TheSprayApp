//
//  TestViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/19/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    let pictures: [UIImage] = [UIImage(named: "dominic")!,UIImage(named: "dominic")!]
    let titles: [String] = ["Dominic", "Awele"]
    let descriptions: [String] = ["This people are awesome", "This Woman is my wife and she is awesome"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! TestTableViewCell
//        cell.configure(picture: pictures[indexPath.row], title: titles[indexPath.row], description: descriptions[indexPath.row])
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! TestTableViewCell
            //set the data here
            cell.configure(picture: pictures[indexPath.row], title: titles[indexPath.row], description: descriptions[indexPath.row])
            return cell
        }
//        else if indexPath.row == 1 {
//            let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.Default, reuseIdentifier: "secondCustomCell")
//            //set the data here
//            return cell
//        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell2", for: indexPath) as! Test2TableViewCell
            
            cell.configure(picture: pictures[indexPath.row], title: titles[indexPath.row], description: descriptions[indexPath.row])
            //set the data here
            return cell
        }
       // return cell
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
