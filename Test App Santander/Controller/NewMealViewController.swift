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

class NewMealViewController: UIViewController {
    
    var itemDelegate: ItemDelegate?
    
    var items = [Item]()
    var itemsSelected: [Item] = []

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var happinessLabel: UILabel!
    @IBOutlet weak var hapinessTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        nameLabel.textColor = .systemRed
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        let addItemBarButton = UIBarButtonItem(title: "Add Item", style: .plain, target: self, action: #selector(self.addNewItem))
        navigationItem.rightBarButtonItem = addItemBarButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func addNewItem() {
        let addNewItemViewController = AddNewItemViewController()
        addNewItemViewController.newItemDelegate = self
        self.navigationController?.pushViewController(addNewItemViewController, animated: true)
    }
    
    @objc func didTapOnView() {
        view.endEditing(true)
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        nameTextField.resignFirstResponder()
        hapinessTextField.resignFirstResponder()
        
        guard let name = nameTextField.text,
              let happinessString = hapinessTextField.text,
              let happiness = Int(happinessString)
        else {
            showAlert(title: "Campos Vazios", message: "Preencha os campos corretamente")
            return
        }
        
        let meal = Meal(name: name, happiness: happiness, items: itemsSelected)
        UserData.meals.append(meal)
        
        itemDelegate?.add()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewMealViewController: UITableViewDataSource, UITableViewDelegate {
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

extension NewMealViewController: NewItemDelegate {
    func add(_ item: Item) {
        items.append(item)
        saveItems(items: items)
        self.itemsTableView.reloadData()
    }
}

extension NewMealViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let tableView = itemsTableView, let touchView = touch.view, touchView.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}

extension NewMealViewController {
    func loadItems() {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let itemsURL = directoryURL.appendingPathComponent("itens")
        
        do {
            let itemsData = try Data(contentsOf: itemsURL)
            guard let items = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(itemsData) as? [Item] else { return }
            self.items = items
        } catch {
            showAlert(title: "Erro ao carregar itens", message: error.localizedDescription)
        }
        itemsTableView.reloadData()
    }
    
    func saveItems(items: [Item]) {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let itemsURL = directoryURL.appendingPathComponent("itens")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
            try data.write(to: itemsURL)
        } catch {
            showAlert(title: "Erro ao salvar itens", message: error.localizedDescription)
        }
    }
}
