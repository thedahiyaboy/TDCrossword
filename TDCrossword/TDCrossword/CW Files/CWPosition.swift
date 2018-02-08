//
//  CWPosition.swift
//  TDCrossword
//
//  Created by Isols Group on 25/01/18.
//  Copyright © 2018 dahiyaboy. All rights reserved.
//

import Foundation

class CWPosition : NSObject {
    var row : Int?
    var col : Int?
    
    init(row : Int, col : Int) {
        self.row = row
        self.col = col
    }
}
