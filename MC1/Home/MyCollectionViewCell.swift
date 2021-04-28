//
//  MyCollectionViewCell.swift
//  MC1
//
//  Created by Maitri Vira on 28/04/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MyCollectionViewCell"
    
    var dataHabit: DataHabit!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    func updateUI(){
        timeLabel.text = dataHabit.timeLabel
        habitLabel.text = dataHabit.habitLable
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

struct DataHabit{
    var timeLabel: String
    var habitLable: String
    var progress: Int
}
