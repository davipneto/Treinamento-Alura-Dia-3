//
//  AddNewItemViewController.swift
//  Test App Santander
//
//  Created by Curitiba01 on 02/09/21.
//

import UIKit

protocol NewItemDelegate {
    func add(_ item: Item)
}

class AddNewItemViewController: UIViewController {
    
    var newItemDelegate: NewItemDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var calTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adicionar Item"
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        guard let name = nameTextField.text,
              !name.isEmpty,
              let calText = calTextField.text,
              let cal = Double(calText)
        else {
            showErrorAlert(title: "Campos Vazios", message: "Preencha os campos corretamente")
            return
        }
        
        let item = Item(name: name, cal: cal)
        newItemDelegate?.add(item)
        
        self.navigationController?.popViewController(animated: true)
    }
}
