//
//  SignUpViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hiddedTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddedTextLabel.isHidden = true
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func hideKeyboard() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        let invalidErrors = checkInvalidErrors(firstName: firstName, lastName: lastName, email: email, password: password)
        if (invalidErrors.count > 0) {
            self.hiddedTextLabel.isHidden = false;
            self.hiddedTextLabel.textColor = UIColor.red;
            self.hiddedTextLabel.text = invalidErrors.joined(separator: "\n")
            return
        } else {
            self.hiddedTextLabel.isHidden = true;
            self.hiddedTextLabel.text = "Hidden"
        }
        
        signUpUser(firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if (self.isInvalidUser(user: user)) {
                        self.showAlert(title: "Sign Up Failed", message: user.error!)
                        return;
                    } else {
                        self.showAlert(title: "Account Created", message: "Please verify your account through your email.")
                        return
                    }
                    
                }
            case .failure(let error):
                print("Sign Up API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Sign Up Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func checkInvalidErrors(firstName: String, lastName: String, email: String, password: String) -> [String] {
        var errors: [String] = []
        
        if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
            errors.append("Fields cannot be blank")
        }
        
        if (!isValidEmail(email)) {
            errors.append("Email is invalid")
        }
        
        if (!isComplexPassword(password)) {
            errors.append("Password must be at least 8 characters and include one uppercase letter, digit, and special character")
        }
        
        return errors
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isComplexPassword(_ password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let hasCapitalLetter = capitalTest.evaluate(with: password)

        let numberRegEx  = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let hasNumber = numberTest.evaluate(with: password)

        let specialCharacterRegEx  = ".*[?!&^%$#@()/]+.*"
        let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let hasSpecialCharacter = specialCharacterTest.evaluate(with: password)

        return (password.count >= 8 && hasCapitalLetter && hasNumber && hasSpecialCharacter)
    }
    
    func isInvalidUser(user: User) -> Bool {
        return (user.userId == "" || user.error!.count > 0)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: { action in
                // Handle the OK button action (if needed)
            }
        )
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
