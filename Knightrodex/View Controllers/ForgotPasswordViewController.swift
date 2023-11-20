//
//  ForgotPasswordViewController.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/20/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var resetCodeField: UITextField!
    @IBOutlet weak var hiddedTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hiddedTextLabel.isHidden = true
    }
    
    @IBAction func didTapResetCodeButton(_ sender: Any) {
        let email = emailField.text!
        
        sendResetCode(email: email) { result in
            switch result {
            case .success(let error):
                DispatchQueue.main.async {
                    if (!error.isEmpty) {
                        self.showAlert(title: "Reset Code Failed", message: error)
                        return;
                    }
                    self.showAlert(title: "Reset Code Sent", message: "If the email above belongs to an existing account, the reset code should arrive shortly.")
                }
            case .failure(let error):
                print("Reset Code API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Reset Code Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func didTapUpdatePasswordButton(_ sender: Any) {
        let email = emailField.text!
        let resetCode = Int(resetCodeField.text!) ?? -1
        let password = passwordField.text!
        let retypePassword = retypePasswordField.text!
        
        let invalidErrors = checkInvalidErrors(email: email, resetCode: resetCode, password: password, retypePassword: retypePassword)
        if (invalidErrors.count > 0) {
            self.hiddedTextLabel.isHidden = false;
            self.hiddedTextLabel.textColor = UIColor.red;
            self.hiddedTextLabel.text = invalidErrors.joined(separator: "\n")
            return
        } else {
            self.hiddedTextLabel.isHidden = true;
            self.hiddedTextLabel.text = "Hidden"
        }
        
        updatePassword(email: email, resetCode: resetCode, newPassword: password) { result in
            switch result {
            case .success(let error):
                DispatchQueue.main.async {
                    if (!error.isEmpty) {
                        self.showAlert(title: "Update Password Failed", message: error)
                        return;
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("Update Password API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Update Password Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func checkInvalidErrors(email: String, resetCode: Int, password: String, retypePassword: String) -> [String] {
        var errors: [String] = []
        
        if (email.isEmpty || password.isEmpty || retypePassword.isEmpty) {
            errors.append("Fields cannot be blank")
        }
        
        if (!isValidEmail(email)) {
            errors.append("Email is invalid")
        }
        
        if (resetCode == -1) {
            errors.append("Reset code is invalid")
        }
        
        if (!isComplexPassword(password)) {
            errors.append("Password must be at least 8 characters and include one uppercase letter, digit, and special character")
        }
        
        if (password != retypePassword) {
            errors.append("Passwords must match")
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
