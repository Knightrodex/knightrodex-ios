//
//  ViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        loginUser(email: emailTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                // Handle successful login, e.g., navigate to the next screen
                DispatchQueue.main.async {
                    // Update UI or navigate to the next view controller
                    
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

