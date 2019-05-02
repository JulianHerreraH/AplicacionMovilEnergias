//
//  SignUpViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/17/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate{
    var successfulAccount = false
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.hideKeyboardWhenTappedAround()
        emailField.setBottomBorder()
        firstNameField.setBottomBorder()
        
        lastNameField.setBottomBorder()
        passwordField.setBottomBorder()
        confirmPasswordField.setBottomBorder()
        // Do any additional setup after loading the view.
    }
    
    func noEmptyFields () -> Bool {
        if emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && confirmPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
            firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
            lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            return true
        }
        return false
    }
    
    func createAccount(){
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { ( user, error) in
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                let alert = UIAlertController(title: "Cuidado", message: firebaseError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            let alert = UIAlertController(title: "Éxito", message: "Tu cuenta ha sido creada", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: {_ in
                self.performSegue(withIdentifier: "succesfulAccountCreated", sender: nil)
            }))
            var ref:DatabaseReference = Database.database().reference()
            ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("perfil").setValue(["Nombre(s)": self.firstNameField.text!])
            ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("perfil").updateChildValues(["Apellido(s)": self.lastNameField.text!])
            
            
            self.present(alert, animated: true)
            self.successfulAccount = true
            
        }
    }
    @IBAction func createAccountWasClicked(_ sender: Any) {
        let firstNameHasNumbers = firstNameField.text!.rangeOfCharacter(from: .decimalDigits)
        print("HASNUMNERSS")
        let lastNameHasNumbers = lastNameField.text!.rangeOfCharacter(from: .decimalDigits)
        let firstNameHasSpecialChars = firstNameField.text!.rangeOfCharacter(from: .symbols)
        let lastNameHasSpecialChars = lastNameField.text!.rangeOfCharacter(from: .symbols)
         if !noEmptyFields() {
            let alert = UIAlertController(title: "Cuidado", message: "Completa todas las casillas", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if passwordField.text != confirmPasswordField.text {
            let alert = UIAlertController(title: "Cuidado", message: "Las Contraseñas no coinciden", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if passwordField.text!.count < 6 {
            let alert = UIAlertController(title: "Cuidado", message: "La contraseña debe tener al menos 6 caracteres", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !emailField.text!.contains("@") {
            let alert = UIAlertController(title: "Cuidado", message: "Ingresa un correo válido", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if firstNameHasNumbers != nil && lastNameHasNumbers != nil && firstNameHasSpecialChars != nil && lastNameHasSpecialChars != nil{
            let alert = UIAlertController(title: "Cuidado", message: "Ingresa un nombre válido sin simbolos ni números", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Regresar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            createAccount()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            textField.resignFirstResponder()
            firstNameField.becomeFirstResponder()
        }
        else if textField == firstNameField {
            firstNameField.resignFirstResponder()
            lastNameField.becomeFirstResponder()
            
        }
        else if textField == lastNameField {
            lastNameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            passwordField.resignFirstResponder()
            confirmPasswordField.becomeFirstResponder()
            
        }
        else if textField == confirmPasswordField {
            confirmPasswordField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(successfulAccount){
            let next = segue.destination as! LoginPageViewController
            next.receivedEmail = self.emailField.text!
            next.receivedPassword = self.passwordField.text!
        }
        
    }
    
    
}
