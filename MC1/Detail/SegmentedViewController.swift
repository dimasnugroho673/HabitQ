//
//  SegmentedViewController.swift
//  segmentedV2
//
//  Created by sulthan syarif on 28/04/21.
//

import UIKit
import CoreData
import AudioToolbox



class SegmentedViewController: UIViewController {
    
    var habit = [Habit]()
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    weak var protocolDelegate: readData?
    weak var delegate: CreateHabitDelegate?
    
    var indexData = 0
    var timeHabit = ""
    var repeatData = ""
    var durationData = ""
    var addTimeValue = ""
    var nameHabit = ""
    var goals = ""
    var progressHabit = 0.0
    
    var collectionView: UICollectionView?
    
    @IBOutlet weak var viewManual: UIView!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var viewReachedTarget: UIView!
    
    
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var addProgressButton: UIButton!
    @IBOutlet weak var addProgressManualButton: UIButton!
    @IBOutlet weak var manualProgressModeButton: UIButton!
    @IBOutlet weak var timerProgressModeButton: UIButton!
    
    @IBOutlet weak var hapusButton: UIButton!
    
    var addProgressMode = "Manual"
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    let data = ["10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes", "35 minutes", "40 minutes", "45 minutes", "50 minutes", "55 minutes", "60 minutes", "90 minutes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        start.setTitleColor(UIColor.green, for: .normal)
        
        habitTitleLabel.text = nameHabit
        goalsLabel.text = goals
        repeatLabel.text = repeatData
        durationLabel.text = "\(durationData) minutes"
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        hapusButton.layer.cornerRadius = 5
        addProgressButton.layer.cornerRadius = 5
        addProgressManualButton.layer.cornerRadius = 5
        
        // check style for didload
        if addProgressMode == "Manual" {
            manualProgressModeButton.tintColor = .link
            manualProgressModeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            timerProgressModeButton.tintColor = .gray
        } else {
            manualProgressModeButton.tintColor = .gray
            timerProgressModeButton.tintColor = .link
            timerProgressModeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
         
        viewManual.isHidden = false
        viewTimer.isHidden = true
        
        if progressHabit == 1 {
            viewReachedTarget.isHidden = false
            viewTimer.isHidden = true
            viewManual.isHidden = true
            
            let tapticFeedback = UINotificationFeedbackGenerator()
            tapticFeedback.notificationOccurred(.success)
        } else {
            viewReachedTarget.isHidden = true
        }
        
        
        print("OLD PROGRESS", Float(progressHabit))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        let habitRequest:NSFetchRequest<Habit> = Habit.fetchRequest()
        let sort = [NSSortDescriptor(key: "nameHabit", ascending: true)]
        habitRequest.sortDescriptors = sort
        
        do {
            try habit = manageObjectContext.fetch(habitRequest)
            collectionView?.reloadData()
        } catch {
            print("error")
        }
    }
    
    @IBAction func addManualProgress(_ sender: Any) {
        loadData()
        
        let time = addTimeValue.prefix(2)
        
        var resultProgress: Float = 0.0
        
        if progressHabit == 0.0 {
            resultProgress = Float(time)! / Float(durationData)!
            
            let progress = resultProgress
       
            if progress >= 1.0 {
                resultProgress = 1
            } else {
                resultProgress = progress
            }
        } else {
            let newProgress = Float(time)! / Float(durationData)!
        
            let oldProgress = Float(progressHabit)
            
            let progress = oldProgress + newProgress
       
            if progress >= 1.0 {
                resultProgress = 1
            } else {
                resultProgress = progress
            }
            
        }
        
        habit[indexData].progressHabit = resultProgress
        
        do {
            try manageObjectContext.save()
//            print("save: \(habit[indexData])")
//            print("habit: \(habit)")
        } catch let error as NSError {
            print("error: \(error)")
        }
        
        delegate?.habitDidSave(nameHabit: "", timeHabit: "", repeatTime: "", durationHabit: 0, goals: "")
        
        if resultProgress == 1 {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        } else {
            let tapticFeedback = UINotificationFeedbackGenerator()
            tapticFeedback.notificationOccurred(.success)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hapus(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: "Delete '\(nameHabit)' Habit?", preferredStyle: .actionSheet)
        
        let deleteButtonOnActionSheet = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.loadData()

            self.protocolDelegate?.load()

            let tobeDelete = self.habit[self.indexData]
            self.deleteData(name: tobeDelete.nameHabit ?? "")

            self.delegate?.habitDidSave(nameHabit: "", timeHabit: "", repeatTime: "", durationHabit: 0, goals: "")
            
            print("Delete habit!")
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelButtonOnActionSheet = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Canceled delete habit!")
        }
        
        actionSheet.addAction(deleteButtonOnActionSheet)
        actionSheet.addAction(cancelButtonOnActionSheet)
        present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func deleteData(name: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        fetchRequest.predicate = NSPredicate(format: "nameHabit = %@", name)
        
        do {
            let object = try manageObjectContext.fetch(fetchRequest)
            let objectToDelete = object[0] as! NSManagedObject
            manageObjectContext.delete(objectToDelete)
            
            do {
                try manageObjectContext.save()
            } catch {
                print("error save")
            }
            
        } catch {
            print("error")
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func buttonTest(_ sender: Any) {
        
        addProgressMode = "Manual"
        
        manualProgressModeButton.tintColor = .link
        manualProgressModeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        timerProgressModeButton.tintColor = .gray
        
        viewManual.isHidden = false
        viewTimer .isHidden = false
    }
    
    @IBAction func buttonTimer(_ sender: Any) {
        
        addProgressMode = "Timer"
        
        manualProgressModeButton.tintColor = .gray
        timerProgressModeButton.tintColor = .link
        timerProgressModeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        viewTimer .isHidden = true
        viewManual.isHidden = false
    }
    
    @IBAction func startButton(_ sender: Any) {
        if(timerCounting){
            timerCounting = false
            timer.invalidate()
            start.setTitle("Start", for: .normal)
            start.setTitleColor(UIColor.green, for: .normal)
        }else{
            timerCounting = true
            start.setTitle("Stop" , for: .normal)
            start.setTitleColor(UIColor .red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void{
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return ((seconds / 3600),((seconds % 3600)/60),((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
        
    }
    
    
    @IBAction func resertButton(_ sender: Any) {
        let alert = UIAlertController(title: "Resert Timer", message: "Are You Sure You Wold like to reset Timer?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in //do nothing
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(_) in
            self.count = 0
            self.timer.invalidate()
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.start.setTitle("Start", for: .normal)
            self.start.setTitleColor(UIColor.green, for: .normal)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SegmentedViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension SegmentedViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addTimeValue = data[row]
    }
}

