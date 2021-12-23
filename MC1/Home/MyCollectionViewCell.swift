//
//  MyCollectionViewCell.swift
//  MC1
//
//  Created by Maitri Vira on 28/04/21.
//

import UIKit
import CoreData

class MyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MyCollectionViewCell"
    
    var dataHabit: Habit!
    
    @IBOutlet weak var timeHabit: UILabel!
    @IBOutlet weak var nameHabit: UILabel!
    @IBOutlet weak var progressHabit: UIProgressView!
    @IBOutlet weak var reachedGoalImage: UIImageView!
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    func updateUI(){
        timeHabit.text = dataHabit.nameHabit
        progressHabit.progress = dataHabit.progressHabit
        nameHabit.text = "\(String(dataHabit.durationHabit)) minutes daily"
        
        if dataHabit.progressHabit == 1 {
            reachedGoalImage.image = UIImage(systemName: "checkmark.seal.fill")
            layer.cornerRadius = 10
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemGreen.cgColor
            progressHabit.progressTintColor = UIColor.systemGreen
            
        } else {
            reachedGoalImage.image = nil
            layer.cornerRadius = 10
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray5.cgColor
            progressHabit.progressTintColor = UIColor.systemTeal
        }
        
        
        

        timeHabit.numberOfLines = 2
        timeHabit.tintColor = .black
       
        nameHabit.tintColor = .systemGray5
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
//        layer.borderColor = UIColor.systemTeal.cgColor
        layer.borderColor = UIColor.systemGray5.cgColor
    }
}
