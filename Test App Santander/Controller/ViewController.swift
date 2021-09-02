//
//  ViewController.swift
//  Test App Santander
//
//  Created by Curitiba01 on 30/08/21.
//

import UIKit

protocol ItemDelegate {
    func add()
}

class ViewController: UIViewController {
    
    var itemDelegate: ItemDelegate?
    
    var items = [
        Item(name: "Molho de Tomate", cal: 30.2),
        Item(name: "Manjericão", cal: 2),
        Item(name: "Parmesão", cal: 40.7),
        Item(name: "Muçarela", cal: 89.3),
        Item(name: "Aipim", cal: 50)
    ]
    var itemsSelected: [Item] = []

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var happinessLabel: UILabel!
    @IBOutlet weak var hapinessTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.textColor = .systemRed
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        let addItemBarButton = UIBarButtonItem(title: "Add Item", style: .plain, target: self, action: #selector(self.addNewItem))
        navigationItem.rightBarButtonItem = addItemBarButton
    }
    
    @objc func addNewItem() {
        let addNewItemViewController = AddNewItemViewController()
        addNewItemViewController.newItemDelegate = self
        self.navigationController?.pushViewController(addNewItemViewController, animated: true)
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        nameTextField.resignFirstResponder()
        hapinessTextField.resignFirstResponder()
        
        guard let name = nameTextField.text,
              let happinessString = hapinessTextField.text,
              let happiness = Int(happinessString)
        else {
            showErrorAlert(title: "Campos Vazios", message: "Preencha os campos corretamente")
            return
        }
        
        let meal = Meal(name: name, happiness: happiness, items: itemsSelected)
        UserData.meals.append(meal)
        
        itemDelegate?.add()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let row = indexPath.row
        
        let item = items[row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let selectedItem = items[indexPath.row]
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            if let index = itemsSelected.firstIndex(where: { item in
                return item.name == selectedItem.name
            }) {
                itemsSelected.remove(at: index)
            }
        } else {
            cell?.accessoryType = .checkmark
            itemsSelected.append(selectedItem)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        view.endEditing(true)
    }
}

extension ViewController: NewItemDelegate {
    func add(_ item: Item) {
        items.append(item)
        self.itemsTableView.reloadData()
    }
}
