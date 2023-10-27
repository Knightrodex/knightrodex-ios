//
//  SignUpViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        signUpUser(firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!) { result in
            switch result {
            case .success(let user):
                // Handle successful login, e.g., navigate to the next screen
                DispatchQueue.main.async {
                    // Update UI or navigate to the next view controller
                    print(user) // Remove this
                    self.dismiss(animated: true, completion: nil) // May need to come back for this
                    
                }
            case .failure(let error):
                // Handle login failure, e.g., show an error message
                print("Login failed: \(error)")
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
    

