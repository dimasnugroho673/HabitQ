//
//  Habit+CoreDataProperties.swift
//  MC1
//
//  Created by Maitri Vira on 29/04/21.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var nameHabit: String?
    @NSManaged public var timeHabit: String?
    @NSManaged public var repeatHabit: String?
    @NSManaged public var durationHabit: Int32
    @NSManaged public var goals: String?
    @NSManaged public var progressHabit: Float
    @NSManaged public var timeProgress: Int32

}

extension Habit : Identifiable {

}
