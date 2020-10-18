//
//  color.swift
//  Study Partner
//
//  Created by Walid Sheykho on 10/17/20.
//  Copyright © 2020 WS. All rights reserved.
//

import Foundation
import UIKit


class color {
    
    var colors : [UIColor] = [UIColor.red, UIColor.orange, UIColor.green, UIColor.magenta, UIColor.purple, UIColor.systemTeal, UIColor.yellow]
    var coldColors : [UIColor] = [UIColor.purple, UIColor.cyan, UIColor.blue, UIColor.green, UIColor.magenta, UIColor.systemTeal, UIColor.white]
    
    func getColors() -> UIColor {
        let random = Int.random(in: 0..<colors.count - 1)
        return colors[random]
    }
    
    func getColdColors() -> UIColor {
        
        let random = Int.random(in: 0..<coldColors.count - 1)
        return coldColors[random]
    }
}
