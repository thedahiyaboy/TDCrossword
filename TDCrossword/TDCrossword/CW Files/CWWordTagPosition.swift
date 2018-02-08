//
//  CWWordTagPosition.swift
//  TDCrossword
//
//  Created by Isols Group on 27/01/18.
//  Copyright © 2018 dahiyaboy. All rights reserved.
//

import UIKit

class CWWordTagPosition: NSObject {

    var tag : Int?
    var index : Int?
    
    init(tag : Int , index : Int) {
        self.tag = tag
        self.index = index
    }
    
}
