//
//  OrderViewModel.swift
//  Expresso
//
//  Created by Omran Khoja on 12/31/19.
//  Copyright © 2019 AcronDesign. All rights reserved.
//

import Foundation

class OrderListViewModel {
    
    var orderViewModels: [OrderViewModel]
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.orderViewModels[index]
    }

    init() {
        self.orderViewModels = [OrderViewModel]()
    }
}
struct OrderViewModel {
    let order: Order
    
    var name: String {
        return self.order.name
    }
    
    var email: String {
        return self.order.email
    }
    
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
