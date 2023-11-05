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
                    // ===== Note to self: Should we also pass the data in here????? ====
                    User.save(user)
                    self.showHome()
                }
            case .failure(let error):
                // Handle login failure, e.g., show an error message
                print("bad credential")
                print("Login failed: \(error)")
            }
        }
    }
    
    
    func showHome() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

