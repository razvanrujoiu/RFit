import Foundation

import UIKit
import HealthKit
import WatchConnectivity
import LKAlertController

class WorkoutViewController: BaseViewController, WCSessionDelegate {
 
    
    // MARK: Properties
    
    var configuration : HKWorkoutConfiguration?
    let healthStore = HKHealthStore()
    var wcSessionActivationCompletion : ((WCSession)->Void)?
    let wcSession = WCSession.default()
    
    var heartImages : [UIImage] = []
    
    
    @IBOutlet var workoutSessionState : UILabel!
    
    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var heartImageView: UIImageView!
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            imageArray.append(image)
        }
        return imageArray
    }
    
    func setupReturnButton(){
        returnButton.layer.cornerRadius = 15
        returnButton.layer.borderColor = UIColor.white.cgColor
        returnButton.clipsToBounds = true
        returnButton.layer.borderWidth = 1
        returnButton.backgroundColor = .clear
        returnButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func animate(imageView: UIImageView, images: [UIImage]){
        imageView.animationImages = images
        imageView.animationDuration = 1.0
       // imageView.animationRepeatCount
        imageView.startAnimating()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignBackground()
        setupReturnButton()
        
       self.heartImages = createImageArray(total: 6, imagePrefix: "heart")
        
        DispatchQueue.main.async {
            self.animate(imageView: self.heartImageView, images: self.heartImages)
        }
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startWatchApp()
    }
    
    
    // MARK: Convenience
    
    func startWatchApp() {
        guard let workoutConfiguration = configuration else { return }
        
        getActiveWCSession { (watchSession) in
            if watchSession.activationState == .activated && watchSession.isWatchAppInstalled {
                self.healthStore.startWatchApp(with: workoutConfiguration, completion: { (success, error) in
                    if let error = error {
                        Alert(message: error.localizedDescription).showOkay()
                    }
                })
            }
        }
    }

    func getActiveWCSession(completion: @escaping (WCSession)->Void) {
        guard WCSession.isSupported() else { return }
        
        wcSession.delegate = self
        
        if wcSession.activationState == .activated {
            completion(wcSession)
        } else {
            wcSession.activate()
            wcSessionActivationCompletion = completion
        }
    }
    
    @IBAction func returnButtonAction(_ sender: Any) {
//        wcSession.activationState = .inactive
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSessionState(_ state: String) {
        DispatchQueue.main.async {
            self.workoutSessionState.text = state
            
            if state == "ended" {
                self.heartImageView.stopAnimating()
            }
            
        }
    }
    
    // MARK: WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            if let activationCompletion = wcSessionActivationCompletion {
                activationCompletion(session)
                wcSessionActivationCompletion = nil
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let state = message["State"] as? String {
            updateSessionState(state)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        heartImageView.stopAnimating()
    }
    
    
}
