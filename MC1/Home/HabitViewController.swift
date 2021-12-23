//
//  HabitViewControllerTwo.swift
//  MC1
//
//  Created by Maitri Vira on 28/04/21.
//

import UIKit
import CoreData

class HabitViewController: UIViewController, CreateHabitDelegate {
    
    
    func habitDidSave(nameHabit: String, timeHabit: String, repeatTime: String, durationHabit: Int, goals: String) {
        loadData()
        
        if habit == [] {
            noHabitsView.isHidden = false
        } else {
            noHabitsView.isHidden = true
        }
    }
    
    var habit = [Habit]()
    
    var index = 0
    var timeHabit = ""
    var repeatTime = ""
    var durationTime = ""
    var nameHabit = ""
    var goals = ""
    var progressHabit = 0.0
    
    @IBOutlet weak var noHabitsView: UIView!
    
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.itemSize = CGSize(width: 170, height: 170)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        collectionView?.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView?.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        view.addSubview(collectionView!)
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        loadData()
        
        if habit == [] {
            noHabitsView.isHidden = false
        } else {
            noHabitsView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        
        if habit == [] {
            noHabitsView.isHidden = false
        } else {
            noHabitsView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: SegmentedViewController.self){
            let detailVC = segue.destination as! SegmentedViewController
            
            detailVC.indexData = index
            detailVC.timeHabit = timeHabit
            detailVC.repeatData = repeatTime
            detailVC.durationData = durationTime
            detailVC.nameHabit = nameHabit
            detailVC.progressHabit = progressHabit
            detailVC.goals = goals
        }
        
        if let vc = segue.destination as? CreateHabitViewController {
            vc.delegate = self
        }
        
        if let vc = segue.destination as? SegmentedViewController {
            vc.delegate = self
        }
        
    }
}

extension HabitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let habitData = habit[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
        cell.dataHabit = habitData
        cell.updateUI()
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        timeHabit = habit[indexPath.row].timeHabit ?? ""
        repeatTime = habit[indexPath.row].repeatHabit ?? ""
        durationTime = String(habit[indexPath.row].durationHabit)
        nameHabit = habit[indexPath.row].nameHabit ?? ""
        progressHabit = Double(habit[indexPath.row].progressHabit)
        goals = habit[indexPath.row].goals ?? ""
        
        
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
    
}
