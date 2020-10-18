//
//  ViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/17/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var minStepper: UIStepper!
    
    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBOutlet weak var minLabel: UILabel!
    
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var createSessionButton: UIButton!
    
    static var myName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        createSessionButton.isEnabled = false
    }
    
    
    @IBAction func changeTime(_ sender: UIStepper) {
        
        minutesLabel.text = String(Int(sender.value))
    }
    
    @IBAction func createSessionAction(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let uid = UUID().uuidString
        
        SetUpViewController.uid = uid
        db.collection("sessions").document(uid).setData([ViewController.myName : true, "Active" : false, "Time" : Int(minStepper.value)]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if nameTextField.text != nil {
            createSessionButton.isEnabled = true
            ViewController.myName = nameTextField.text!
        }
        
        return false
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSegue" {
            
            
        }
    }

}

