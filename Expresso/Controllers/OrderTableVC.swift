//
//  OrdersListTableVC.swift
//  Expresso
//
//  Created by Omran Khoja on 12/31/19.
//  Copyright © 2019 AcronDesign. All rights reserved.
//

import Foundation
import UIKit

class OrderTableVC: UITableViewController, AddToOrderDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let addOrderVC = navController.viewControllers.first as? AddToOrderVC
            else {
                fatalError("Error performing segue!")
        }
        addOrderVC.delegate = self
    }
    
    //MARK: - Delegate functions for AddOrderDelegate
    func addToOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderVM = OrderViewModel(order: order)
        orderListViewModel.orderViewModels.append(orderVM)
        tableView.insertRows(at: [IndexPath.init(row: orderListViewModel.orderViewModels.count - 1, section: 0)], with: .automatic)
    }
    
    func addToOrderViewControllerDidCancel(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
        
    }
    
    private func populateOrders() {
        guard URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") != nil else {
            fatalError("URL was incorrect")
        }
        
        Webservice().load(resource: Order.all) { result in
            
            switch result {
            case .success(let orders):
                self.orderListViewModel.orderViewModels = orders.map(OrderViewModel.init)
                self.tableView.reloadData()
                print(orders)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
    
}
