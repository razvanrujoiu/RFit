//
//  AboutViewController.swift
//  RFit
//
//  Created by Razvan Rujoiu on 15/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import UIKit
import LKAlertController




class AboutViewController: BaseViewController {

    @IBOutlet weak var mainView: UIView!
    
    @IBAction func btnExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    func setupViews() {
        self.mainView.backgroundColor = .clear
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor.white.cgColor
        self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = true
        
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 20
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assignBackground()
        self.setupViews()
        
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
