//
//  Order.swift
//  OrderApp
//
//  Created by Berry, Brett A. (Student) on 11/15/24.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
