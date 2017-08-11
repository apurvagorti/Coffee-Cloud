//
//  ThankYouViewController.swift
//  Hackday
//
//  Created by Katherine Curtis on 6/8/17.
//  Copyright © 2017 Katherine Curtis. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var totalString:String! = ""
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTotal = formatter.string(from: currentUser.total! as NSNumber) {
            totalString = "\(formattedTotal)"
        }
        
        totalLabel.text = "You have saved "+totalString+" by using Coffee Cloud"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
