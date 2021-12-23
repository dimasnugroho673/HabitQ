//
//  CreateHabitViewController.swift
//  MC1
//
//  Created by Dimas Putro on 28/04/21.
//
//
import UIKit
import CoreData


class CreateHabitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var habit = [Habit]()
    var newTitle = ""
    var isNewCreate: Bool = true
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 2. property of the delegate
    weak var delegate: CreateHabitDelegate?
    
    @IBOutlet weak var nameHabitInput: UITextField!
    @IBOutlet weak var timeNotifPicker: UITextField!
    @IBOutlet weak var durationPickerText: UITextField!
    @IBOutlet weak var goalsInput: UITextField!
    
    let timePicker = UIDatePicker()
    let durationPicker = UIPickerView()
    let repeatPicker = UIPickerView()
    
    let dataDuration = ["10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes", "35 minutes", "40 minutes", "45 minutes", "50 minutes", "55 minutes", "60 minutes", "90 minutes"]
    
    var selectedDuration = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataDuration.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataDuration[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDuration = dataDuration[row]
        durationPickerText.text = selectedDuration
        
        print("didselect", selectedDuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createTimePicker()
        createDurationPicker()
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        durationPicker.dataSource = self
        durationPicker.delegate = self
        
        if isNewCreate {
            nameHabitInput.text = ""
        } else {
            nameHabitInput.text = "\(newTitle)"
        }
        
        
        
        print("newTitle", newTitle)
    }
    
    func addData(){
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: manageObjectContext)
        
        let newHabit = NSManagedObject(entity: entity!, insertInto: manageObjectContext)
        
        if let name = nameHabitInput.text{
            newHabit.setValue(name, forKey: "nameHabit")
        }
        
        if let time = timeNotifPicker.text{
            newHabit.setValue(time, forKey: "timeHabit")
        }
        
        if let durationHabit = durationPickerText.text {
            let tmpDurationHabit = Int(durationHabit.prefix(2))
            
            newHabit.setValue(tmpDurationHabit, forKey: "durationHabit")
        }
        
        newHabit.setValue("Every Day", forKey: "repeatHabit")
        
        if let goals = goalsInput.text{
            newHabit.setValue(goals, forKey: "goals")
        }
        
        do {
            try manageObjectContext.save()
            print("save: \(newHabit)")
        } catch let error as NSError {
            print("error: \(error)")
        }
    }
    
    @IBAction func cancelCreateHabitButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveHabitButton(_ sender: Any) {
        addData()
        
        
        delegate?.habitDidSave(nameHabit: nameHabitInput.text ?? "", timeHabit: timeNotifPicker.text ?? "", repeatTime: "Every Day", durationHabit: 30, goals: goalsInput.text ?? "")
        
        let tapticFeedback = UINotificationFeedbackGenerator()
        tapticFeedback.notificationOccurred(.success)
        
        dismiss(animated: true)
    }
    
    func createDurationPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
   
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(durationPickerDonePressed))
        toolbar.setItems([doneBtn], animated: true)

        self.durationPickerText.inputAccessoryView = toolbar
        self.durationPickerText.inputView = durationPicker
    }
    
    @objc func durationPickerDonePressed() {
   
        durationPickerText.text = selectedDuration
        print("done", selectedDuration)
        self.view.endEditing(true)
    }
    
    func createTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
   
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timePickerDonePressed))
        toolbar.setItems([doneBtn], animated: true)
   
        self.timePicker.datePickerMode = .time
        self.timePicker.preferredDatePickerStyle = .wheels
        self.timeNotifPicker.inputAccessoryView = toolbar
        self.timeNotifPicker.inputView = timePicker
   
    }
   
    @objc func timePickerDonePressed() {
   
        let formatter = DateFormatter()
   
        formatter.timeStyle = .medium
   
        timeNotifPicker.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }

}
