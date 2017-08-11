//
//  ViewController.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Auth.auth().signInAnonymously() { (user, error) in
            let uid = user!.uid
            
            print("Signing in anonymously...")
            print(uid)
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginUser(_ sender: Any) {
        
        getUser(userName: userName.text!, completionHandler: { (result) in
            
            //No user found with username, create account
            if (result.firstName == ""){
                
                //Switch to first time login view
                if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "SetupAccountViewController") as? SetupAccountViewController {
                    
                    resultController.newUser = result
                    self.present(resultController, animated: true, completion: nil)
                }
            }
            else{
                //Switch to order view
                
                if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "OrderViewController") as? OrderViewController {
                    
                    resultController.currentUser = result
                    self.present(resultController, animated: true, completion: nil)
                }
            }
            
        
        })
    
    }
    
    func getUser(userName: String, completionHandler: @escaping (User) -> ()) {
        
        var currentUser: User!

        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(userName).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() {

                let userInfo:[String:AnyObject] = snapshot.value as! [String: AnyObject]
                print(userInfo)
                
                var recentDrinks:[Drink] = []
                var favoriteDrinks:[Drink] = []

                
                let total: Double = (userInfo["total"] as? Double)!
                
                let firstName: String = (userInfo["first_name"] as? String)!
                print("Recents!!!")
                print(userInfo["recents"])
                if(userInfo["recents"] != nil){
                    print("getting recents...")
                    let recents: [[String: AnyObject]]  = (userInfo["recents"] as? [[String: AnyObject]])!
                    
                        for (_, value) in recents.enumerated() {
                        
                            let myDrink: [String: AnyObject] = value
                        
                            let newDrink: Drink = Drink(
                            category: (myDrink["category"]! as? String)!,
                            milk: (myDrink["milk"]! as? String)!,
                            syrup: (myDrink["syrup"]!as? String)!,
                            shots: (myDrink["shots"]! as? String)!,
                            iced: (myDrink["iced"]! as? String)!,
                            decaf: (myDrink["decaf"]! as? String)!,
                            cup: (myDrink["cup"]! as? String)!)
                        
                            recentDrinks.append(newDrink)
                        
                        }
                    
                }
                print("Favorites!!!")
                print(userInfo["favorites"])
                if(userInfo["favorites"] != nil){
                    let favorites: [[String:AnyObject]] = (userInfo["favorites"] as? [[String: AnyObject]])!
                
                    for (_, value) in favorites.enumerated() {
                    
                    
                        let myDrink: [String: AnyObject] = value
                    
                        let newDrink: Drink = Drink(
                        category: (myDrink["category"]! as? String)!,
                        milk: (myDrink["milk"]! as? String)!,
                        syrup: (myDrink["syrup"]!as? String)!,
                        shots: (myDrink["shots"]! as? String)!,
                        iced: (myDrink["iced"]! as? String)!,
                        decaf: (myDrink["decaf"]! as? String)!,
                        cup: (myDrink["cup"]! as? String)!)
                    
                        favoriteDrinks.append(newDrink)
                    
                    }
                }
                
                print("got it from the db :)")
                
                currentUser = User(firstName: firstName, userName: userName, recents: recentDrinks, favorites: favoriteDrinks, total: total)
                completionHandler(currentUser)
            }
            else{
                currentUser = User(firstName: "", userName: userName)
                completionHandler(currentUser)
            }
        })
        
    }



}

