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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        loginUser(email: emailTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if (self.isInvalid(user: user)) {
                        self.showAlert(title: "Login Failed", message: user.error)
                        return;
                    }
                    
                    User.save(user)
                    self.showHome()
                }
            case .failure(let error):
                print("Login API Call Failed: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func isInvalid(user: User) -> Bool {
        return (user.userId == "" || user.error.count > 0)
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
    
    func showHome() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
}
