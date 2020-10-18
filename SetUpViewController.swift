//
//  SetUpViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/18/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit
import Firebase

class SetUpViewController: UIViewController {

    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var personLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    static var uid = ""
    
    var people = 1
    
    let db  = Firestore.firestore()
    
    var notificationListener : ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        check()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        uidLabel.text = "Share : \(SetUpViewController.uid)"
    }
    
    
    func check() {
        if notificationListener == nil {
            print("listener was added notification")
            notificationListener = db.collection("sessions").document(SetUpViewController.uid)
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
                
                let dataKeys = Array(data.keys)
                
                self.people = data.count - 2
                
                SessionViewController.chosen = Int(truncating: data["Time"] as! NSNumber)
                
                
                for index in 0...(dataKeys.count - 1) {
                    if dataKeys[index].contains("Active") {
                        if data["Active"] as? Bool == true {
                            self.performSegue(withIdentifier: "startSegue", sender: self)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    func setLabel() {
        personLabel.text = " \(people) people"
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        
        let doc = db.collection("sessions").document(SetUpViewController.uid)
        
        doc.updateData(["Active" : true]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    

}
