//
//  AddOrderVC.swift
//  Expresso
//
//  Created by Omran Khoja on 12/31/19.
//  Copyright © 2019 AcronDesign. All rights reserved.
//

import Foundation
import UIKit

protocol AddToOrderDelegate {
    func addToOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addToOrderViewControllerDidCancel(controller: UIViewController)
}



class AddToOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: AddToOrderDelegate?
    
    private var addItemVM = AddItemViewModel()
    private var sizesSegementControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        if let delegate = self.delegate {
            delegate.addToOrderViewControllerDidCancel(controller: self)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let name = nameTextField.text
        let email = emailTextField.text
        
        let selectedSize = sizesSegementControl.titleForSegment(at: self.sizesSegementControl.selectedSegmentIndex)
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Did not select a coffee")
        }
        
        addItemVM.name = name
        addItemVM.email = email
        addItemVM.selectedSize = selectedSize
        addItemVM.selectedType = addItemVM.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: addItemVM)) { result in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addToOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        sizesSegementControl = UISegmentedControl(items: self.addItemVM.sizes)
        sizesSegementControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sizesSegementControl)
        
        sizesSegementControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30).isActive = true
        sizesSegementControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sizesSegementControl.selectedSegmentTintColor = .systemBlue
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.addItemVM.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.addItemVM.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
