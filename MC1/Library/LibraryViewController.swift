//
//  LibraryViewController.swift
//  MC1
//
//  Created by Evita Sihombing on 28/04/21.
//

import UIKit

class LibraryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
//    var nameHabit: String? = nil
    var isNewCreateFromLibrary: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var catagoriesHabitSearchBar: UISearchBar!
    
    let categories = ["Meditate", "Read", "Work on a side project", "Self Improvement" ]
    var filteredCatagories: [String] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCatagories = []
        
        if searchText == "" {
            filteredCatagories = categories
        } else {
            for habit in categories {
                        if habit.lowercased().contains(searchText.lowercased()) {
                            filteredCatagories.append(habit)
                        }
                    }
                    
        }
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCatagories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryViewCell") as! LibraryTableViewCell
        
//        let dataName = categories[indexPath.row]
        cell.labelTitle.text = filteredCatagories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("didselectrow", categories[indexPath.row])
        
        isNewCreateFromLibrary = false
        
        UserDefaults.standard.set(categories[indexPath.row], forKey: "tmpTitleForCreateSegue")
       
        performSegue(withIdentifier: "createHabit", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        definesPresentationContext = true
        
        catagoriesHabitSearchBar.delegate = self
        filteredCatagories = categories
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createHabit" {
            let createHabitViewController = segue.destination as! CreateHabitViewController
            createHabitViewController.isNewCreate = isNewCreateFromLibrary
            createHabitViewController.newTitle = UserDefaults.standard.string(forKey: "tmpTitleForCreateSegue") ?? ""
        }
    }
}
