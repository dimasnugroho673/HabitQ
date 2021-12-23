//
//  ViewController.swift
//  DateTime
//
//  Created by Pelindung Giawa on 28/04/21.
//

import UIKit

class SetHabitViewController: UIViewController {

   
    @IBOutlet weak var textLabelTime: UILabel!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var textLabelRepeat: UILabel!
    @IBOutlet weak var textFieldRepeat: UITextField!
    @IBOutlet weak var textLabelDuration: UILabel!
    @IBOutlet weak var textFieldDuration: UITextField!
    
    
    let durationPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabelTime.text = "Time"
        
        
        let time = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        textFieldTime.text = formatter.string(from: time)
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self,
                             action: #selector(timePickerValueChanged(sender:)),
                             for: UIControl.Event.valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 250)
        textFieldTime.inputView = timePicker
        
        durationPickers()
                
    }
    
    @objc func timePickerValueChanged (sender: UIDatePicker){
    
        //when time is changed it will apper here
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        textFieldTime.text = formatter.string(from: sender.date)
        }
    
    
//    func repeatPicker(){
//
//        textLabelRepeat.text = "Repeat"
//
//        let repeats: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
////        let formatRepeat = DateFormatter
////        formatRepeat.locale = Locale(identifier: "en_gb")
//        let textFieldRepeat = UIDatePicker()
//        self.textFieldRepeat.preferred
//
//    }
    
    func durationPickers(){
       
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
   
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(durationPickerDonePressed))
        toolbar.setItems([doneBtn], animated: true)
   
        self.durationPicker.datePickerMode = .countDownTimer
        self.durationPicker.preferredDatePickerStyle = .wheels
        self.textFieldDuration.inputAccessoryView = toolbar
        self.textFieldDuration.inputView = durationPicker
    }
    
    @objc func durationPickerDonePressed() {
   
        let formatter = DateFormatter()
   
        formatter.timeStyle = .full
   
        textFieldDuration.text = formatter.string(from: durationPicker.date)
        self.view.endEditing(true)
    }
        
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
        
//        let textFieldDuration = Date()
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_gb")
//        formatter.dateFormat = "HH:mm"
//        textLabelDuration.text = formatter.string(from: textFieldDuration)
//
//        let durationPicker = UIDatePicker()
//        durationPicker.datePickerMode = .time
//        durationPicker.addTarget(self,
//                             action: #selector(durationPickerValueChanged(sender:)),
//                             for: UIControl.Event.valueChanged)
//        durationPicker.frame.size = CGSize(width: 0, height: 250)
//        textFieldTime.inputView = durationPicker
//
    
    
//    @objc func durationPickerValueChanged (sender: UIDatePicker){
//
//        //when time is changed it will apper here
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_gb")
//        formatter.dateFormat = "HH:mm"
//        textFieldDuration.text = formatter.string(from: sender.date)
//        }
        
    }



