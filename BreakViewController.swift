//
//  BreakViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/17/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit
import Firebase

class BreakViewController: UIViewController {

    @IBOutlet weak var breakLabel: UILabel!
    
    @IBOutlet weak var leaveButton: UIButton!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    
    @IBOutlet weak var image1RightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image1TopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image2TopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var image2LeftConstraint: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    
    var red = 0.0
    var blue = 0.0
    var green = 0.0
    
    var direction = true
    
    var imageTracker = 0
    
    var timer = Timer()
       var counterMinutes = 5
       var counterSeconds = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        breakLabel.text = "Take a break \(ViewController.myName)"
        
        image1.layer.masksToBounds = true
        image1.layer.cornerRadius = image1.frame.width / 2
        
        
        image2.layer.masksToBounds = true
        image2.layer.cornerRadius = image1.frame.width / 2
        
        image2.alpha = 0
        image1.alpha = 0
        
        image1.backgroundColor = color().getColdColors()
        image2.backgroundColor = color().getColdColors()
        
        
        green = 0.5
        blue = 0.5
        self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        
        direction = true
        imageTracker = 5
        
        counterSeconds = 0
        
        if counterSeconds < 10 {
            timerLabel.text = "\(counterMinutes):0\(counterSeconds)"
        } else {
            timerLabel.text = "\(counterMinutes):\(counterSeconds)"
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func UpdateTimer() {
        if counterMinutes == 0 && counterSeconds == 0 {
            timer.invalidate()
            performSegue(withIdentifier: "returnSegue", sender: self)
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
        
        if green < 0.75  && true{
            
            green += 0.005
            blue -= 0.005
            
            if blue == 0.25 {
                direction = false
            }
            self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
            
        } else if blue < 0.75  && direction == false {
            
            blue += 0.005
            green -= 0.005
            
            if green == 0.25 {
                direction = true
            }
            self.view.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        }
        
    }
    
    
    @IBAction func leaveAction(_ sender: UIButton) {
        
        db.collection("sessions").document(SetUpViewController.uid).updateData([ViewController.myName : FieldValue.delete()]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.timer.invalidate()
            self.performSegue(withIdentifier: "return2Segue", sender: self)
            SetUpViewController.uid = ""
        }
        
    }
    
    
    func imageMover1() {
        
        let number1 = Int.random(in: 200...Int(view.frame.height - 200))
        let number2 = Int.random(in: 50...Int(view.frame.width - 50))
        
        image1TopConstraint.constant = CGFloat(number1)
        image1RightConstraint.constant = CGFloat(number2)
        
        image1.backgroundColor = color().getColdColors()
        
    }
    
    func imageMover2() {
        
        let number3 = Int.random(in: 200...Int(view.frame.height - 200))
        let number4 = Int.random(in: 50...Int(view.frame.width - 50))
        
        image2LeftConstraint.constant = CGFloat(number4)
        image2TopConstraint.constant = CGFloat(number3)
        
        image2.backgroundColor = color().getColdColors()
    }
    
    
    func flash1() {
        
        UIView.animate(withDuration: 3, animations: {
            self.image1.alpha = 1
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
            self.image2.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 3, animations: {
                self.image2.alpha = 0
            }) { (true) in
                self.imageMover2()
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
