//
//  SessionViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/17/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit
import Firebase

class SessionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var leaveButton: UIButton!
    
    
    @IBOutlet weak var sendIdeaBotton: UIButton!
    
    @IBOutlet weak var ideaTextField: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var ideaLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image2BottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image2leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image1RightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image1TopConstraint: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    
    
    var users : ListenerRegistration? = nil
    var chat : ListenerRegistration? = nil
    
    var timer = Timer()
    static var chosen = 25
    var counterMinutes = 0
    var counterSeconds = 0
    
    var ideas : [String] = []
    
    var red = 0.0
    var blue = 0.0
    var green = 0.0
    
    var direction = true
    
    var imageTracker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideaTextField.delegate = self

        // Do any additional setup after loading the view.
        check()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ideaLabel.alpha = 0
        addButton.isHidden = true
        addButton.isEnabled = false
        ideaTextField.alpha = 0
        ideaTextField.isEnabled = false
        
        
        image1.layer.masksToBounds = true
        image1.layer.cornerRadius = image1.frame.width / 2
        
        
        image2.layer.masksToBounds = true
        image2.layer.cornerRadius = image1.frame.width / 2
        
        
        image2.alpha = 0
        image1.alpha = 0
        
        image1.backgroundColor = color().getColors()
        image2.backgroundColor = color().getColors()
        
        //counterMinutes = SessionViewController.chosen
        counterMinutes = 1
        
        counterSeconds = 0
        
        direction = true
        imageTracker = 5
        
        if counterSeconds < 10 {
            timerLabel.text = "\(counterMinutes):0\(counterSeconds)"
        } else {
            timerLabel.text = "\(counterMinutes):\(counterSeconds)"
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        red = 0.5
        blue = 0.5
        self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        
    }
    
    
    @IBAction func addIdeaAction(_ sender: UIButton) {
        
        ideas.append(ideaLabel.text!)
        
    }
    
    func check() {
        
        if chat == nil {
            print("chat listener was added notification")
            chat = db.collection("sessions").document(SetUpViewController.uid).collection("chat").document("chat_doc")
            .addSnapshotListener { documentSnapshot, error in
               
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                
                self.ideaLabel.text = data["message"] as? String
                self.addButton.isHidden = false
                self.addButton.isEnabled = true
                UIView.animate(withDuration: 5, animations: {
                    self.ideaLabel.alpha = 1
                    
                }) { (true) in
                    
                    UIView.animate(withDuration: 5, delay: 5, options: .curveLinear, animations: {
                        self.ideaLabel.alpha = 0
                        
                    }) { (true) in
                    self.addButton.isHidden = true
                    self.addButton.isEnabled = false
                    }
                }
                
            }
        }
        
        
        if users == nil {
            
            users = db.collection("sessions").document(SetUpViewController.uid)
            .addSnapshotListener { documentSnapshot, error in
              
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                
                
                if data.count == 2 {
                }
                
            }
        }
        
    }
    
    
    @IBAction func leaveAction(_ sender: UIButton) {
        
        db.collection("sessions").document(SetUpViewController.uid).updateData([ViewController.myName : FieldValue.delete()]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.timer.invalidate()
            self.performSegue(withIdentifier: "return1Segue", sender: self)
            SetUpViewController.uid = ""
        }
        
        
    }
    
    @IBAction func sendIdeaAction(_ sender: Any) {
        self.ideaTextField.isEnabled = true
        UIView.animate(withDuration: 2) {
            self.ideaTextField.alpha = 1
            
        }
        
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if ideaTextField.text != nil {
            db.collection("sessions").document(SetUpViewController.uid).collection("chat").document("chat_doc").setData(["message" : ideaTextField.text!], merge: false) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
            }
        }
        ideaTextField.text = nil
        UIView.animate(withDuration: 2) {
            self.ideaTextField.alpha = 0
            self.ideaTextField.isEnabled = false
        }
        
        return true
    }
    
    
    
    @objc func UpdateTimer() {
        if counterMinutes == 0 && counterSeconds == 0 {
            timer.invalidate()
            
            performSegue(withIdentifier: "fullSegue", sender: self)
        } else if counterSeconds == 0 {
            changeColor()
            imageTracker += 1
            
            
            counterMinutes -= 1
            counterSeconds = 59
        } else {
            changeColor()
            imageTracker += 1
            
            
            counterSeconds = counterSeconds - 1
        }
        
        if imageTracker == 6 {
            flash1()
        } else if imageTracker == 12 {
            flash2()
            imageTracker = 0
        }
        
        if counterSeconds < 10 {
            timerLabel.text = "\(counterMinutes):0\(counterSeconds)"
        } else {
            timerLabel.text = "\(counterMinutes):\(counterSeconds)"
        }
    }
    
    
    func changeColor() {
        
        if red < 0.75  && true{
            
            red += 0.01
            blue -= 0.01
            
            if blue == 0.25 {
                direction = false
            }
            self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
            
        } else if blue < 0.75  && direction == false {
            
            blue += 0.01
            red -= 0.01
            
            if red == 0.25 {
                direction = true
            }
            self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        }
        
    }
    
    func imageMover1() {
        
        let number1 = Int.random(in: 200...Int(view.frame.height - 200))
        let number2 = Int.random(in: 50...Int(view.frame.width - 50))
        
        image1TopConstraint.constant = CGFloat(number1)
        image1RightConstraint.constant = CGFloat(number2)
        
        image1.backgroundColor = color().getColors()
        
    }
    
    func imageMover2() {
        
        let number3 = Int.random(in: 200...Int(view.frame.height - 200))
        let number4 = Int.random(in: 50...Int(view.frame.width - 50))
        
        image2leftConstraint.constant = CGFloat(number4)
        image2BottomConstraint.constant = CGFloat(number3)
        
        image2.backgroundColor = color().getColors()
    }
    
    
    func flash1() {
        
        UIView.animate(withDuration: 3, animations: {
            self.image1.alpha = 0.25
        }) { (true) in
            UIView.animate(withDuration: 3, animations: {
                self.image1.alpha = 0
            }) { (true) in
                self.imageMover1()
            }
        }
        
    }
    
    func flash2() {
        
        
        UIView.animate(withDuration: 3, animations: {
            self.image2.alpha = 0.25
        }) { (true) in
            UIView.animate(withDuration: 3, animations: {
                self.image2.alpha = 0
            }) { (true) in
                self.imageMover2()
            }
        }
        
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fullSegue" {
            let nextVC = segue.destination as! IdeasViewController
            nextVC.ideasArray = ideas
        }
    }
    

}
