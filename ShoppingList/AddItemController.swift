//
//  AddItemController.swift
//  ShoppingList
//
//  Created by Tiffany Obi on 7/15/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol AddItemVCDelegate:AnyObject {
    func didAddItem(item: Item, addItemVC:AddItemController)
}
class AddItemController: UIViewController {
    
    @IBOutlet weak private var nameTextField: UITextField!
    
    @IBOutlet weak private var priceTextfield: UITextField!
    
    @IBOutlet weak private var pickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    
   private var itemName: String?
   private var itemPrice: String?
    
    private var catergory:Category?

    weak var addItemDelegate: AddItemVCDelegate?
    
   private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
       setUpTextfields()
       setUpPickerView()
        navigationItem.title = "Add New Item"
        catergory = Category.allCases.first
    }
    
    private func setUpTextfields(){
        nameTextField.delegate = self
        priceTextfield.delegate = self
    }
    
    private func setUpPickerView(){
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    @objc private func resignTextfeilds(){
        nameTextField.resignFirstResponder()
        priceTextfield.resignFirstResponder()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let itemName = itemName, let itemPrice = itemPrice, let catergory = catergory else {return}
        
        let item = Item(name: itemName, price: Double(itemPrice)!, category: catergory)
        
        addItemDelegate?.didAddItem(item: item, addItemVC: self)
       
        
        dismiss(animated: true)
    }
    

}

extension AddItemController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            guard !(textField.text?.isEmpty ?? true) else {return}
            
            itemName = textField.text
        }
        
        if textField == priceTextfield {
            guard !(textField.text?.isEmpty ?? true) else {return}
          
            
            itemPrice = textField.text
        }
    }
    
}

extension AddItemController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        catergory = Category.allCases[row]
    }
    
}
