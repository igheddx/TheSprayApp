//
//  Validation.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 9/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
class Validation {
    public func validateName2(name2: String) -> (isValidate: Bool, errorMsg: String) {
       // Length be 18 characters max and 3 characters minimum, you can always modify.
        
        //if text?.utf16.count==0{
//        var isValidate: Bool = false
//        var errorMessage: String = ""
//        switch name2 {
//            case "" :
//                errorMessage = "Field cannot be empty"
//                isValidate = false
//                return (isValidate, errorMessage)
//            case eventDateTimeTextField:
//                self.borderForTextField(textField: eventDateTimeTextField, validationFlag: true)
//                eventDateTimeErrorLabel.isHidden = false
//                eventDateTimeErrorLabel.text = "Missing Event Date & Time"
//                eventDateTimeTextField.becomeFirstResponder()
//
//            default:
//                break
//        //}
        
        
        var isValidate: Bool = false
        var errorMessage: String = ""
        if name2.count == 0 {
            isValidate = false
            errorMessage = ""
            errorMessage = "Text Field Cannot Be Empty"
            return (isValidate, errorMessage)
        } else if name2.count < 3 {
            isValidate = false
            errorMessage = "Text Field Cannot Be Empty Less Than 3 Characters"
            return (isValidate, errorMessage)
        } else if name2.count > 25  {
            isValidate = false
            errorMessage = "Text Field Cannot Be Empty Exceed 25 Characters"
            return (isValidate, errorMessage)
        } else {
            isValidate = true
            errorMessage = ""
            return (isValidate, errorMessage)
        }
//       let nameRegex = "\\w{3,25}$"
//       let trimmedString = name2.trimmingCharacters(in: .whitespaces)
//       let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
//       let isValidateName = validateName.evaluate(with: trimmedString)
//       return isValidateName
    }
    
    public func validateNumTextField(incomingValue: String) -> (isValidate: Bool, errorMsg: String) {
        
        var isValidate: Bool = false
        var errorMessage: String = ""
        if incomingValue.count == 0 {
            isValidate = false
            errorMessage = ""
            errorMessage = "Text Field Cannot Be Empty"
            return (isValidate, errorMessage)
//        } else if incomingValue.count < 3 {
//            isValidate = false
//            errorMessage = "Text Field Cannot Be Less Than 3 Characters"
//            return (isValidate, errorMessage)
        } else {
            isValidate = true
            errorMessage = ""
            return (isValidate, errorMessage)
        }
//       let nameRegex = "\\w{3,25}$"
//       let trimmedString = name2.trimmingCharacters(in: .whitespaces)
//       let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
//       let isValidateName = validateName.evaluate(with: trimmedString)
//       return isValidateName
    }
    
    public func validateName(name: String) ->Bool {
      // Length be 18 characters max and 3 characters minimum, you can always modify.
      let nameRegex = "^\\w{3,18}$"
      let trimmedString = name.trimmingCharacters(in: .whitespaces)
      let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
      let isValidateName = validateName.evaluate(with: trimmedString)
      return isValidateName
   }
   public func validaPhoneNumber(phoneNumber: String) -> Bool {
      let phoneNumberRegex = "^\\d{3}-\\d{3}-\\d{4}$" //"^[6-9]\\d{9}$"
      let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
      let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
      let isValidPhone = validatePhone.evaluate(with: trimmedString)
      return isValidPhone
   }
   public func validateEmailId(emailID: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
      let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      let isValidateEmail = validateEmail.evaluate(with: trimmedString)
      return isValidateEmail
   }
   public func validatePassword(password: String) -> Bool {
      //Minimum 8 characters at least 1 Alphabet and 1 Number:
      let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
      let trimmedString = password.trimmingCharacters(in: .whitespaces)
      let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
      let isvalidatePass = validatePassord.evaluate(with: trimmedString)
      return isvalidatePass
   }
   public func validateAnyOtherTextField(otherField: String) -> Bool {
      let otherRegexString = "Your regex String"
      let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
      let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
      let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
      return isValidateOtherString
   }
}
