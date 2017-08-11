//
//  User.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase


class User {
    
    var firstName:String?
    var userName:String?
    var recents:[Drink]?
    var favorites:[Drink]?
    var total: Double?
    
    init(firstName: String, userName: String){
        
        self.firstName = firstName
        self.userName = userName
        self.recents = []
        self.favorites = []
        total = 0.0
    }
    
    init(firstName: String, userName: String, recents: [Drink], favorites: [Drink], total: Double){
        
        self.firstName = firstName
        self.userName = userName
        self.recents = recents
        self.favorites = favorites
        self.total = total
    }

    
    //add add drink to list (either favorites or recents or both)
    func addDrink(list: String, drink: Drink){
        
        if(list == "recents"){
            print("added to recents")
            self.recents?.append(drink)
        }
        else if (list == "favorites"){
            self.favorites?.append(drink)
        }
        else{
            print("Something went wrong...")
        }
        
    }
    
    func addToTotal(amount: Double){
        self.total  = self.total! + amount
    }
    
        
}
    
    
    
