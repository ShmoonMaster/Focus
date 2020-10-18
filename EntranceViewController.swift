//
//  EntranceViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/18/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit
import Firebase

class EntranceViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var uidTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        uidTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.alpha = 0
        enterButton.isEnabled = false
    }
    
    @IBAction func enterAction(_ sender: UIButton) {
        
        if nameTextField != nil && nameTextField.text?.count != 0 &&
            uidTextField != nil && uidTextField.text?.count != 0 {
            
            db.collection("sessions").document(uidTextField.text!).getDocument { (snapshot, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let doc = snapshot {
                    if doc.data() != nil {
                        
                        self.db.collection("sessions").document(self.uidTextField.text!).setData([self.nameTextField.text!: true], merge: true) { (error) in
                            if error != nil {
                                print(error!.localizedDescription)
                                return
                            }
                            ViewController.myName = self.nameTextField.text!
                            SetUpViewController.uid = self.uidTextField.text!
                            self.performSegue(withIdentifier: "enterAttemptSegue", sender: self)
                        }
                    } else {
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "Please fix the UID ;)"
                        return
                    }
                }
                
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if nameTextField != nil && nameTextField.text?.count != 0 &&
        uidTextField != nil && uidTextField.text?.count != 0 {
            enterButton.isEnabled = true
        }
        return true
    }
    
    

}
