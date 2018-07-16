//
//  RegisterViewController.swift
//  SpeedySloth
//
//  Created by Razvan Rujoiu on 06/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import UIKit
import LKAlertController
import Firebase

class RegisterViewController: BaseViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func backToLoginArrowButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignBackground()
        setupViews()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
       self.usernameTextField.backgroundColor = .clear
        self.usernameTextField.textColor = .white
        self.usernameTextField.layer.cornerRadius = 15
        self.usernameTextField.clipsToBounds = true
        self.usernameTextField.layer.borderWidth = 1
        self.usernameTextField.layer.borderColor = UIColor.white.cgColor
        
        self.emailTextField.backgroundColor = .clear
        self.emailTextField.textColor = .white
        self.emailTextField.layer.cornerRadius = 15
        self.emailTextField.clipsToBounds = true
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        
        self.passwordTextField.backgroundColor = .clear
        self.passwordTextField.textColor = .white
        self.passwordTextField.layer.cornerRadius = 15
        self.passwordTextField.clipsToBounds = true
        self.passwordTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.isSecureTextEntry = true
        
        self.confirmPasswordTextField.backgroundColor = .clear
        self.confirmPasswordTextField.textColor = .white
        self.confirmPasswordTextField.layer.cornerRadius = 15
        self.confirmPasswordTextField.clipsToBounds = true
        self.confirmPasswordTextField.layer.borderWidth = 1
        self.confirmPasswordTextField.layer.borderColor = UIColor.white.cgColor
        self.confirmPasswordTextField.isSecureTextEntry = true
        
        self.registerButton.backgroundColor = .clear
        self.registerButton.setTitleColor(UIColor.white, for: .normal)
        self.registerButton.layer.cornerRadius = 15
        self.registerButton.clipsToBounds = true
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
//    func setupArrow(){
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(arrowTapped(tapGestureRecognizer:)))
//        backImageView.isUserInteractionEnabled = true
//        backImageView.addGestureRecognizer(tapGestureRecognizer)
//    }
//    func arrowTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        _ = tapGestureRecognizer as! UIImageView
//        self.navigationController?.pushViewController(LoginViewController(), animated: true)
//    }
    
    private func registerUserIntoDatabaseWithUUID(uid: String, values: [String: AnyObject]){
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
                Alert(message: err?.localizedDescription).showOkay()
                return
            }
            let user = User(dictionary: values)
            self.dismiss(animated: true, completion: nil)
            Alert(message: "Succesfully registered").showOkay()
            
        }
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        handleRegister()
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            print("Form is not valid")
            Alert(message: "Complete all input fields").showOkay()
            return
        }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if self.passwordTextField.text! != self.confirmPasswordTextField.text {
                Alert(message: "Passwords don't match").showOkay()
                return
            } else if error != nil {
                print(error)
                Alert(message: error?.localizedDescription).showOkay()
                return
            } else {
                
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                Alert(message: "Succefully registered").showOkay()
                guard let uid = user?.user.uid else {
                    return
                }
            }
            
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "registerSegue" {
//            let vc = segue.destination as! MainViewController
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
