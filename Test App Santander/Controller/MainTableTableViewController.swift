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
        loadMeals()
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
        cell.itemsLabel.text = meal.getItemsString()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPressOnCell))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Célula \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func didLongPressOnCell(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let cell = gesture.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell)
              else { return }
        
        let meals = UserData.meals
        let meal = meals[indexPath.row]
        
        let title = meal.name
        let itemsString = meal.getItemsString()
        let message = "Felicidade \(meal.happiness)\n\(itemsString)"
        
        let action = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            UserData.meals.remove(at: indexPath.row)
            self.saveMeals(meals: UserData.meals)
            self.tableView.reloadData()
        }
        
        showAlert(title: title, message: message, actions: [action])
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewItemController" {
            if let newItemViewController = segue.destination as? NewMealViewController {
                newItemViewController.itemDelegate = self
            }
        }
    }
}

// MARK: - Delegate
extension MainTableTableViewController: ItemDelegate {
    // TODO: implementar depois
    func add() {
        saveMeals(meals: UserData.meals)
        tableView.reloadData()
    }
    
    func loadMeals() {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let mealsURL = directoryURL.appendingPathComponent("refeicoes")
        
        do {
            let mealsData = try Data(contentsOf: mealsURL)
            guard let meals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mealsData) as? [Meal] else { return }
            UserData.meals = meals
        } catch {
            showAlert(title: "Erro ao carregar refeições", message: error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveMeals(meals: [Meal]) {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let mealsURL = directoryURL.appendingPathComponent("refeicoes")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: mealsURL)
        } catch {
            showAlert(title: "Erro ao salvar refeições", message: error.localizedDescription)
        }
    }
}
