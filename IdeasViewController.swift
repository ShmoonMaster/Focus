//
//  IdeasViewController.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/17/20.
//  Copyright © 2020 WS. All rights reserved.
//

import UIKit

class IdeasViewController: UIViewController {

    @IBOutlet weak var IdeasTableView: UITableView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var ideasArray : [String] = []
    
    var timer = Timer()
    var counterMinutes = 0
    var counterSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IdeasTableView.delegate = self
        IdeasTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        counterSeconds = 30
        
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
            
            ideasArray.removeAll()
            performSegue(withIdentifier: "breakSegue", sender: self)
        } else if counterSeconds == 0 {
            counterMinutes -= 1
            
        } else {
            counterSeconds = counterSeconds - 1
        }
        
        
        if counterSeconds < 10 {
            timerLabel.text = "\(counterMinutes):0\(counterSeconds)"
        } else {
            timerLabel.text = "\(counterMinutes):\(counterSeconds)"
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

extension IdeasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IdeasTableView.dequeueReusableCell(withIdentifier: "IdeaCell", for: indexPath) as! IdeasTableViewCell
        cell.backgroundColor = .clear
        print(ideasArray[indexPath.row])
        if ideasArray.count != 0 {
            cell.ideaLabel.text = ideasArray[indexPath.row]
        }
        
        return cell
        
    }
    
    
    
    
}
