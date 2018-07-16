//
//  MainViewController.swift
//  SpeedySloth
//
//  Created by Razvan Rujoiu on 06/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import UIKit
import Firebase
import LKAlertController
import GoogleMobileAds
import FirebaseAuth

class MainViewController: BaseViewController , GADBannerViewDelegate{

    
    
   
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    @IBOutlet weak var tutorialsButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var aboutButton: UIButton!
    
    
    var bannerView : GADBannerView!
    
    func setupViews(){
        
        startWorkoutButton.layer.cornerRadius = 15
        startWorkoutButton.layer.borderColor = UIColor.white.cgColor
        startWorkoutButton.clipsToBounds = true
        startWorkoutButton.layer.borderWidth = 1
        startWorkoutButton.backgroundColor = .clear
        startWorkoutButton.setTitleColor(UIColor.white, for: .normal)
    //    startWorkoutButton.titleLabel?.font =
        
        logoutButton.layer.cornerRadius = 15
        logoutButton.layer.borderColor = UIColor.white.cgColor
        logoutButton.clipsToBounds = true
        logoutButton.layer.borderWidth = 1
        logoutButton.backgroundColor = .clear
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        tutorialsButton.layer.cornerRadius = 15
        tutorialsButton.layer.borderColor = UIColor.white.cgColor
        tutorialsButton.clipsToBounds = true
        tutorialsButton.layer.borderWidth = 1
        tutorialsButton.backgroundColor = .clear
        tutorialsButton.setTitleColor(UIColor.white, for: .normal)
        
        aboutButton.layer.cornerRadius = 15
        aboutButton.layer.borderColor = UIColor.white.cgColor
        aboutButton.clipsToBounds = true
        aboutButton.layer.borderWidth = 1
        aboutButton.backgroundColor = .clear
        aboutButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignBackground()
        setupViews()
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: topLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 40),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUser()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func handleLogout(){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: Any?)
        }catch let logoutError {
            print(logoutError)
            Alert(message: "Logout error occured").showOkay()
        }
        
//       self.navigationController?.popToRootViewController(animated: true)
//        let   loginViewController = LoginViewController()
//        self.navigationController?.pushViewController(loginViewController, animated: true)
       
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = User(dictionary: dictionary)
            }
            
        },withCancel: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startWorkoutSegue" {
            let vc = segue.destination as! ConfigurationViewController
        } else if segue.identifier == "tutorialSegue" {
            let vc = segue.destination as! TutorialViewController
        } else if segue.identifier == "segueAbout" {
            let vc = segue.destination as! AboutViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
