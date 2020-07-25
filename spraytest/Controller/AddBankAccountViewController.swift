//
//  AddBankAccountViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class AddBankAccountViewController: UIViewController {

    
    @IBOutlet weak var accountHolderNameTextField: UITextField!
    @IBOutlet weak var accountTypeTextField: UITextField!
    @IBOutlet weak var rountingNumberTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    //@IBOutlet weak var accountTypePicker: UIPickerView!
    
    
    var bankaccount = [BankAccount]()
    
    let accountTypeOption = ["Account Type", "Checking", "Savings"]
  
    
    //instantiate picker view objects
    var accountTypePickerView = UIPickerView()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    //set delete and data source for pickerview
    accountTypePickerView.delegate = self
    accountTypePickerView.dataSource = self
    
   
    
    //set value of pickerview to text fiels
    accountTypeTextField.inputView = accountTypePickerView
    
    //accountTypeTextField.textAlignment = .center
    accountTypeTextField.placeholder =  "Select Account Tpe"
        
        
        self.addBottomLineToTextField(textField: accountHolderNameTextField)
        self.addBottomLineToTextField(textField: accountTypeTextField)
        self.addBottomLineToTextField(textField: rountingNumberTextField)
        self.addBottomLineToTextField(textField: accountNumberTextField)
        
        // Do any additional setup after loading the view.
    }
    
  
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveBankAccountButtonPressed(_ sender: Any) {
        let accountHolderName = accountHolderNameTextField.text
        let accountType = accountTypeTextField.text
        let routingNumber = rountingNumberTextField.text
        let accountNumber = accountNumberTextField.text
        
        let bankaccoundata = BankAccount(accountHolderName: accountHolderName!, accountyType: accountType!, routingNumber: routingNumber!, accountNumber: accountNumber!)
        bankaccount.append(bankaccoundata)
        messageLabel.text = "A new Bank Account has been added... "
    }
    
    
    
    private func addBottomLineToTextField(textField: UITextField) {
          
          let bottomLine = CALayer()
          bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
          bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
          //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
          textField.borderStyle = .none
          
          textField.layer.addSublayer(bottomLine)
          
          //        let border = CALayer()
          //          let borderWidth = CGFloat(1.0)
          //          border.borderColor = UIColor.white.cgColor
          //          border.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.size.width, height: 2)
          //          border.borderWidth = borderWidth
          //          textField.layer.addSublayer(border)
          //          textField.layer.masksToBounds = true
      }
}

extension AddBankAccountViewController: UIPickerViewDataSource {
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        accountTypeOption.count
    }
  }
      
  extension AddBankAccountViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountTypeOption[row]
        
  }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountTypeTextField.text = accountTypeOption[row]
        accountTypeTextField.resignFirstResponder()
    }
}
 
