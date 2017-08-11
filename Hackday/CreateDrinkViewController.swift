//
//  CreateDrinkViewController.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class CreateDrinkViewController: UIViewController {
    
    var myDrink:Drink!
    var currentUser: User!
    @IBOutlet weak var category: UISegmentedControl!
    @IBOutlet weak var milk: UISegmentedControl!
    @IBOutlet weak var syrup: UISegmentedControl!
    @IBOutlet weak var shots: UISegmentedControl!
    @IBOutlet weak var iced: UISegmentedControl!
    @IBOutlet weak var decaf: UISegmentedControl!
    @IBOutlet weak var cup: UISegmentedControl!
    
    var favorite: Bool!
    
    @IBAction func addFavorite(_ sender: Any) {
        favorite = true
    }
    
    override func viewDidLoad() {
        
       
        favorite = false
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func orderDrink(_ sender: Any){
        
        myDrink = Drink(
            category: category.titleForSegment(at: category.selectedSegmentIndex)!,
            milk: milk.titleForSegment(at: milk.selectedSegmentIndex)!,
            syrup: syrup.titleForSegment(at: syrup.selectedSegmentIndex)!,
            shots: shots.titleForSegment(at: shots.selectedSegmentIndex)!,
            iced: iced.titleForSegment(at: iced.selectedSegmentIndex)!,
            decaf: decaf.titleForSegment(at: decaf.selectedSegmentIndex)!,
            cup: cup.titleForSegment(at: cup.selectedSegmentIndex)!)
        
        currentUser.addDrink(list: "recents", drink: myDrink)
        
        if(favorite){
            print("adding to favs")
            currentUser.addDrink(list: "favorites", drink: myDrink)
        }
        currentUser.addToTotal(amount: myDrink.price)

        
        saveUser()
        
        if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "ThankYouViewController") as? ThankYouViewController {
            resultController.currentUser = currentUser
            self.present(resultController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func saveUser() {
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        print("saving user...")
        
        var recentsArray:[[String : String]] = []
        
        for drink in currentUser.recents! {
            
            
            let recentDrink = ["category": drink.category,
                               "milk": drink.milk,
                               "syrup": drink.syrup,
                               "shots": drink.shots,
                               "iced": drink.iced,
                               "decaf": drink.decaf,
                               "cup": drink.cup]
            print("adding to recents")
            recentsArray.append(recentDrink)
            
        }
        
        var favoritesArray:[[String : String]] = []
        
        for drink in currentUser.favorites! {
            
            
            let favDrink = ["category": drink.category,
                            "milk": drink.milk,
                            "syrup": drink.syrup,
                            "shots": drink.shots,
                            "iced": drink.iced,
                            "decaf": drink.decaf,
                            "cup": drink.cup]
            
            favoritesArray.append(favDrink)
            
        }
        
        print("Recents array")
        print(recentsArray)
        print("Favorites array")
        print(favoritesArray)
        
        
        
        
        let user = ["first_name": currentUser.firstName!,
                    "recents": recentsArray,
                    "favorites": favoritesArray,
                    "total": currentUser.total!] as [String : Any]
        
        
        databaseRef.child("users").child(currentUser.userName!).updateChildValues(user)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
