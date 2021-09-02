//
//  MainTableTableViewController.swift
//  Test App Santander
//
//  Created by Curitiba01 on 31/08/21.
//

import UIKit

class MainTableTableViewController: UITableViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealsCell", for: indexPath) as? MealTableViewCell else {
            return UITableViewCell()
        }
        
        let row = indexPath.row
        let meal = UserData.meals[row]
        
        cell.nameLabel.text = meal.name
        cell.happinessLabel.text = "Felicidade \(meal.happiness)"
        cell.itemsLabel.text = meal.items.reduce("", { result, item in
            guard let res = result else { return "" }
            return "\(res)\n\(item.name)"
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Célula \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewItemController" {
            if let newItemViewController = segue.destination as? ViewController {
                newItemViewController.itemDelegate = self
            }
        }
    }
}

// MARK: - Delegate
extension MainTableTableViewController: ItemDelegate {
    // TODO: implementar depois
    func add() {
        tableView.reloadData()
    }
}
