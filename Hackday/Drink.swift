//
//  Drink.swift
//  Hackday
//
//  Created by Apurva Gorti on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import Foundation

class Drink {
    var category: String
    var milk: String
    var syrup: String
    var shots: String
    var iced: String
    var decaf: String
    var cup: String
    var price: Double
    
    init(category: String, milk: String, syrup: String, shots: String, iced: String, decaf: String, cup: String) {
        self.category = category
        self.milk = milk
        self.syrup = syrup
        self.shots = shots
        self.iced = iced
        self.decaf = decaf
        self.cup = cup
        self.price = 0.0
        getPrice()
    }
    
    func getPrice(){
        price = 0.0
        switch category {
            case "Capuccino":
                price += 3.00
            case "Latte":
                price += 3.00
            case "Macchiato":
                price += 3.95
            case "Mocha":
                price += 3.45
            case "Espresso":
                price += 2.00
            case "Chai":
                price += 3.65
            default:
                price += 1.00
        }
        switch shots {
            case "Double":
                price += 0.80
            case "Triple":
                price += 1.60
            case "Crazy":
                price += 2.40
            default:
                price += 0.00
        }
        if syrup != "None" {
            price += 0.50
        }
    }
}
