//
//  CreateHabitDelegate.swift
//  MC1
//
//  Created by Dimas Putro on 29/04/21.
//

import Foundation

protocol CreateHabitDelegate: class {
    
    func habitDidSave(nameHabit: String, timeHabit: String, repeatTime: String, durationHabit: Int, goals: String)
}
