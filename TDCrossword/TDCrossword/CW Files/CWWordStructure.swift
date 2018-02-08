//
//  CWWordStructure.swift
//  TDCrossword
//
//  Created by Isols Group on 25/01/18.
//  Copyright © 2018 dahiyaboy. All rights reserved.
//

import Foundation

class CWWordStructure: NSObject {
    var char : String?
    var index : Int?
    
    init(char : String, index : Int) {
        self.char = char
        self.index = index
    }
}
