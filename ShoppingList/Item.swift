//
//  Item.swift
//  ShoppingList
//
//  Created by Tiffany Obi on 7/15/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct Item:Hashable {
    let name:String
    let price:Double
    let category:Category
    let identifier = UUID()
    
    //implement the hashable propert for Item
    //Hasher is the (hash function) in swift
    
    func hash(into hasher: inout Hasher){
        hasher.combine(identifier)
    }
    
    //test data
    
    static func testData()-> [Item] {
        return [
            Item(name: "Sauna Vest", price: 70.00, category: .fitness),
            Item(name: "Polar Bluetooth Stride Sensor", price: 140.00, category: .technology),
            Item(name: "Cracking the Coding Interview", price: 26.99, category: .education),
            Item(name: "The Pragmatic Programmer", price: 42.35, category: .education),
            Item(name: "Towel hooks", price: 50.00, category: .household),
            Item(name: "Beginner Microscope STEM Kit", price: 39.99, category: .education),
            Item(name: "Fitbit Versa 2", price: 199.95, category: .technology),
            Item(name: "BISSELL Cleanview Swivel Pet", price: 99.99, category: .household),
            Item(name: "Ninja Professional", price: 89.99, category: .household),
            Item(name: "Debrox Swimmer's Ear", price: 7.99, category: .health),
            Item(name: "Tylenol Extra Strength", price: 9.47, category: .health)
        ]
    }
}
