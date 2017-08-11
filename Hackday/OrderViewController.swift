//
//  OrderViewController.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth


class OrderViewController: UIViewController {
    
    var currentUser: User!
    var recentButtons: [UIButton]!

    @IBOutlet var buttons: [UIButton]!
    
    var favButtons: [UIButton]!

    @IBOutlet weak var orderButton: UIButton!

    

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentButtons = [buttons[0], buttons[1],buttons[2],buttons[3],buttons[4]]
        favButtons = [buttons[5], buttons[6],buttons[7],buttons[8],buttons[9]]
        
        
        for (index, element) in buttons.enumerated() {
            element.tag = index
        }

        Auth.auth().signInAnonymously() { (user, error) in
            let uid = user!.uid
            
            print("Signing in anonymously...")
            print(uid)
        }
        print(currentUser)

        welcomeLabel.text = "Hey "+currentUser.firstName! + "! What would you like today?"
        
        
        for button in recentButtons {
            button.isHidden = true
        }
        for (index, element) in (currentUser.recents?.enumerated())! {
            
            var drinkName:String!
            
            if(element.syrup != "None"){
             drinkName =  element.syrup + " " + element.category
            }
            else{
                drinkName = element.category
            }
            
            recentButtons[index].setTitle(drinkName, for: UIControlState.normal)
            recentButtons[index].isHidden = false
        }
        
        for button in favButtons {
            button.isHidden = true
        }
        for (index, element) in (currentUser.favorites?.enumerated())! {
        
            var drinkName:String!
            
            if(element.syrup != "None"){
                drinkName =  element.syrup + " " + element.category
            }
            else{
                drinkName = element.category
            }
        
            favButtons[index].setTitle(drinkName, for: UIControlState.normal)
            favButtons[index].isHidden = false
        }
        
        if(currentUser.recents?.count == 0){
            let noRecentsLabel = UILabel(frame: CGRect(x: 170, y: 315, width: 200, height: 30))
            noRecentsLabel.text = "No recent drinks :("
            self.view.addSubview(noRecentsLabel)
        }

        if(currentUser.favorites?.count == 0){
            let noFavoritesLabel = UILabel(frame: CGRect(x: 730, y: 315, width: 200, height: 30))
            noFavoritesLabel.text = "No favorite drinks :("
            self.view.addSubview(noFavoritesLabel)
        }
        
        if(currentUser.favorites?.count == 0 && currentUser.favorites?.count == 0){
            orderButton.isHidden = true
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBAction func submitOrder(_ sender: Any) {
        
        let myButton:UIButton = sender as! UIButton
        
        var index = myButton.tag
        var myDrink:Drink!
        
        
        if(index >= 4){
            print("selected a fav")
            index = index % 4
            myDrink = currentUser.favorites?[index]
            currentUser.recents?.append(myDrink)
        }
        else {
            myDrink = currentUser.recents?[index]
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
        
        
        databaseRef.child("users").child(currentUser.userName!).setValue(user)
    }
    
    @IBAction func selectDrink(_ sender: UIButton) {
        sender.isSelected = true
        for b in buttons {
            if b != sender {
                b.isSelected = false
            }
        }
    }

    @IBAction func orderNewDrink(_ sender: Any) {
        if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "CreateDrinkViewController") as? CreateDrinkViewController {
            
            resultController.currentUser = currentUser
            self.present(resultController, animated: true, completion: nil)
        }
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
