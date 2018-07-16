//
//  LoginViewController.swift
//  SpeedySloth
//
//  Created by Razvan Rujoiu on 06/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import UIKit
import LKAlertController
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import PKHUD


class LoginViewController: BaseViewController, FBSDKLoginButtonDelegate {

  //  var mainViewController : MainViewController?
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    
    @IBOutlet weak var loginButton: UIButton!
    
  
    @IBOutlet weak var registerButton: UIButton!

    
    
 
    
    
    func setupUIViews(){
        
        self.logoLabel.textColor = UIColor.white
        self.logoLabel.font = UIFont.boldSystemFont(ofSize:48)
        
        
        self.usernameTextField.layer.cornerRadius = 15
        self.usernameTextField.clipsToBounds = true
        self.usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.white.cgColor
        usernameTextField.backgroundColor = .clear
        usernameTextField.textColor = UIColor.white
        
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.backgroundColor = .clear
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = UIColor.white
        
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.clipsToBounds = true
        loginButton.layer.borderWidth = 1
        loginButton.backgroundColor = .clear
        loginButton.setTitleColor(UIColor.white, for: .normal)
  
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignBackground()
        setupUIViews()

        view.addSubview(facebookLoginButton)
        facebookLoginButton.delegate = self
        setupFacebookButton()
        
    }
    
    let facebookLoginButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
        Alert(message: "Did log out of facebook").showOkay()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            Alert(message: error.localizedDescription).showOkay()
            return
        }else{
            self.dismiss(animated: true, completion: nil)
        
            self.navigationController?.popToRootViewController(animated: true)
            print("Succesfully logged in with facebook..")
            Alert(message: "Succefully logged in with facebook..").showOkay()
        }
       
    }

    func setupFacebookButton(){
        self.facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.facebookLoginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -10).isActive = true
        self.facebookLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.facebookLoginButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        //self.facebookLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 30).isActive

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "registerSegue" {
//            let vc = segue.destination as! RegisterViewController
////            let navigation : UINavigationController = segue.destination as! RegisterViewController
//        } else if segue.identifier == "loginSegue" {
//            let vc = segue.destination as! MainViewController
//        }
//
//    }
    
    func handleLogin(){
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            print("Form is invalid")
            Alert(message: "Please complete all input fields").showOkay()
            return
            
        }
        
        HUD.show(.progress)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            HUD.hide()
            
            if error != nil {
                print(error)
              
                Alert(message: error?.localizedDescription).showOkay()
                return
            } else {
              
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
             
                
//                Alert(message: "Succefully logged in").showOkay()
            }
            
         
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        handleLogin()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
