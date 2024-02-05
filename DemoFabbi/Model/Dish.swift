//
//  Dish.swift
//  DemoFabbi
//
//  Created by tientm on 04/02/2024.
//

import Foundation

struct Dishes: Codable {
    
    var dishes: [Dish]
}

struct Dish: Codable {
    
    var id: Int
    var name: String
    var restaurant: String
    var availableMeals: [String]
}
