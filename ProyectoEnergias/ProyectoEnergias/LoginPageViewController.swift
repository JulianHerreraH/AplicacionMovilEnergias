//
//  LoginPageViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/17/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginPageViewController: UIViewController, UITextFieldDelegate {
    var receivedEmail = ""
    var receivedPassword = ""
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    let defaults = UserDefaults.standard

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: "mail") != nil {
            usernameField.text = defaults.object(forKey: "mail") as! String
        }
        usernameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()

        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        usernameField.setBottomBorder()
        passwordField.setBottomBorder()
        
        if receivedEmail != "" {
            usernameField.text = receivedEmail
        }
        if receivedPassword != "" {
            passwordField.text = receivedPassword
        }
        // Do any additional setup after loading the view.
    }
    
  
    @objc func textFieldDidChange(_ textField: UITextField) {
        if usernameField.text != "" && passwordField.text != "" {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
    }
    func validateUserAndPass() -> Bool{
        
        return false
    }
    
    func noEmptyFields () -> Bool {
        if usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            return true
        }
        return false
    }
    
    func checkLogin(){
        self.showSpinner(onView: self.view)
        if let email  = usernameField.text, let pass = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if let firebaseError = error {
                   self.removeSpinner()
                print(firebaseError.localizedDescription)
                    let alert = UIAlertController(title: "Cuidado", message: "Revisa que tu correo y contraseña sean correctos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Regresar", style: .destructive, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.removeSpinner()
                        self.performSegue(withIdentifier: "successfulLogin", sender: nil)
                    self.defaults.set(self.usernameField.text, forKey: "mail")
                    }
                    
                }
            
            }
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if !noEmptyFields() {
            let alert = UIAlertController(title: "Cuidado", message: "Ingresa tu usuario y contraseña", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            checkLogin()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            passwordField.resignFirstResponder()
        }
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        let backItem = UIBarButtonItem()
        backItem.title = "Inicio de Sesión"
        navigationItem.backBarButtonItem = backItem
 
        */
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
