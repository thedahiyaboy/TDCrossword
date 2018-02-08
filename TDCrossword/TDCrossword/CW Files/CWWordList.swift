//
//  CWController.swift
//  TDCrossword
//
//  Created by Isols Group on 25/01/18.
//  Copyright © 2018 dahiyaboy. All rights reserved.
//

import Foundation



class CWWordList: NSObject {
    var word : String?
    var direction : CWDirection?
    var word_tag : Int?
    var hint : String?
    var position : CWPosition?
    
    init(word : String , direction : CWDirection, word_tag : Int, hint : String , position : CWPosition)  {
        self.word = word
        self.direction = direction
        self.word_tag = word_tag
        self.hint = hint
        self.position = position
    }
}
