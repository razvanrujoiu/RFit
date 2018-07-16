//
//  TutorialViewController.swift
//  RFit
//
//  Created by Razvan Rujoiu on 11/07/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import LKAlertController
import Firebase
import FirebaseStorage
import PKHUD

class TutorialViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    @IBOutlet weak var videoPicker: UIPickerView!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    var selectedVideo : String?
    
    var pickerItems : [String] = ["pull ups","one hand pushups",  "deadlifts", "muscle ups","bicep curls","bench press","squats","handstand pushups"]
    
    func setupPlayButton(){
        playButton.layer.cornerRadius = 15
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.clipsToBounds = true
        playButton.layer.borderWidth = 1
        playButton.backgroundColor = .clear
        playButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assignBackground()
        setupPlayButton()
        videoPicker.dataSource = self
        videoPicker.delegate = self
        self.selectedVideo = pickerItems[0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToMainViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == videoPicker {
            return pickerItems.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == videoPicker {
            selectedVideo = pickerItems[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == videoPicker {
            return pickerItems[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerItems[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    

    
    @IBAction func playMovieButton(_ sender: Any) {
        
     
        let pathReference = Storage.storage().reference(withPath: "Videos/\(selectedVideo!).mov")
        HUD.show(.progress)
        DispatchQueue.main.async {
            pathReference.downloadURL { (url, error) in
                if let error = error {
                    Alert(message: error.localizedDescription).showOkay()
                    HUD.hide()
                } else {
                    
                    let player = AVPlayer(url: url!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.view.frame = self.view.bounds
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                        HUD.hide()
                    }
                    
                }
            }
        }
    }
    
    

}
