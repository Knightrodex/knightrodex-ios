//
//  ViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // For Setting Buttons Programatically!!!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    
    let buttonColor = UIColor(red: 247, green: 191, blue: 80, alpha: 255)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Listen for keyboard events
        
        
        // Button Layouts
        
        
        loginButtonOutlet.backgroundColor = buttonColor
        
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        loginUser(email: emailTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if (self.isInvalidUser(user: user)) {
                        self.showAlert(title: "Login Failed", message: user.error!)
                        return;
                    }
                    
                    User.save(user)
                    self.showHome()
                }
            case .failure(let error):
                print("Login API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // Methods
    func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // Don't worry about this for now
    // =====
    // Implementation of having the screen move with the keyboard
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
    }
    // =====
    
    // UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
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
    
    func showHome() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
}
