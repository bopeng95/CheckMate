//
//  Transactions.swift
//  CheckMate
//
//  Created by Kelly Luo on 4/25/18.
//  Copyright © 2018 KB. All rights reserved.
//

import Foundation

class Transactions {
    var name = [String]()
    var amount = [String]()
    var dict:[(String, String)]
    
    init(name: [String], amount:[String]) {
        self.name = name
        self.amount = amount
        self.dict=[]
    }
    
    func toAnyObject(num: Int) -> [(String, String)] {
        for i in 0...num-1 {
            dict.append((name[i],amount[i]))
        }
        return dict
    }
}
