//
//  VisionViewController.swift
//  
//
//  Created by Apurva Gorti on 6/9/17.
//
//

import Foundation
import SalesforceEinsteinVision

class VisionViewController :UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var analysisText: UILabel!
    
    @IBAction func sendUsername(_ sender: Any) {
        
        if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            
            resultController.userName.text = self.analysisText.text
            self.present(resultController, animated: true, completion: nil)
        }
        
        
        
        
    }
    @IBAction func takeAndAnalyzePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
        
        // convert UIImage to base64
        let imageData = UIImageJPEGRepresentation(chosenImage, 0.4)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        // Initialize the service with a valid access token
        let service = PredictionService(bearerToken: "756c84053490b5b113f38d39a888526bbb6c7afc")
        
        
        //Create the dataset
        //        let ds = service?.createDataset(name: "employeeDataSet", labels: ["apurva", "kat"], completion: { (result) in
        //        })
        
        
        // Upload base64 for prediction on the General Image Classifier Model
        service?.predictBase64(modelId: "RPUNP4BOVIXGMYMBEQONFYQ6EI", base64: imageStr, sampleId: "", completion: { (result) in
            
            var resultString = ""
            
            if (result != nil) {
                //                for prob in (result?.probabilities!)! {
                //                    resultString = resultString + prob.label! + " (" + String(prob.probability!) + ")\n"
                //                }
                resultString = resultString + (result?.probabilities?[0].label!)!
            } else {
                resultString = "No data found"
            }
            
            self.analysisText.text = resultString
            
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
