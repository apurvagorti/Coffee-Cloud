//
//  SetupAccountViewController.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth


class SetupAccountViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    var newUser:User!
    @IBOutlet weak var label: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.adjustsFontSizeToFitWidth = true;

        Auth.auth().signInAnonymously() { (user, error) in
            let uid = user!.uid
            
            
            print("Signing in anonymously...")
            print(uid)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     @IBAction func setupAccount(_ sender: Any) {
    
        createUser()
        newUser.firstName = firstName.text
        if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "OrderViewController") as? OrderViewController {
            resultController.currentUser = newUser
            self.present(resultController, animated: true, completion: nil)
        }
    
    }
    
    func createUser() {
        
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        print("creating user...")
        
        let user = ["first_name": firstName.text!,
                    "recents:": [],
                    "favorites": [],
                    "total": 0.00] as [String : Any]
        
        databaseRef.child("users").child(newUser.userName!).setValue(user)
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
