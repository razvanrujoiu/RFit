
import UIKit
import HealthKit

class ConfigurationViewController: BaseViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    
    var selectedActivityType: HKWorkoutActivityType
    
    var selectedLocationType: HKWorkoutSessionLocationType
    
    let activityTypes: [HKWorkoutActivityType] = [.basketball, .cycling, .hiking, .jumpRope, .pilates, .running, .soccer, .swimming, .tableTennis, .walking, .yoga ]
    let locationTypes: [HKWorkoutSessionLocationType] = [ .indoor, .outdoor, .unknown]
    
    // MARK: IBOutlets

    
    
    @IBOutlet var activityTypePicker: UIPickerView!
    @IBOutlet var locationTypePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designStartButton()
        self.assignBackground()
        
    }
    
    @IBOutlet var startButton: UIButton!
    func designStartButton() {
        self.startButton.backgroundColor = .clear
        self.startButton.layer.cornerRadius = 10
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.white.cgColor
        self.startButton.setTitle("Start", for: .normal)
        self.startButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        selectedActivityType = activityTypes[0]
        selectedLocationType = locationTypes[0]
        super.init(coder: coder)
    }

    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == activityTypePicker {
            return activityTypes.count
        } else if pickerView == locationTypePicker {
            return locationTypes.count
        }
        
        return 0
    }

    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == activityTypePicker {
            return format(activityType: activityTypes[row])
        } else if pickerView == locationTypePicker {
            return format(locationType: locationTypes[row])
        }
        
        return nil
    }

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == activityTypePicker {
            let titleData = format(activityType: activityTypes[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        } else if pickerView == locationTypePicker {
            let titleData = format(locationType: locationTypes[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == activityTypePicker {
            selectedActivityType = activityTypes[row]
        } else if pickerView == locationTypePicker {
            selectedLocationType = locationTypes[row]
        }
    }

    
    @IBAction func didTapStartButton() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = selectedActivityType
        workoutConfiguration.locationType = selectedLocationType
        
        
        if let workoutViewController = storyboard?.instantiateViewController(withIdentifier: "WorkoutViewController") as? WorkoutViewController {
            workoutViewController.configuration = workoutConfiguration
            present(workoutViewController, animated: true, completion:nil)
        }
    }
    
    @IBAction func returnToMainViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

