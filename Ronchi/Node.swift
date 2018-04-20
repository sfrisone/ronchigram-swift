//
//  Node.swift
//  Ronchi
//
//  Created by LeBeau Group iMac on 11/14/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//

import Foundation

class Node:NSObject {
    
    var title = "Node"
    //var value = Float(0)
    var isGroup = false
    var children = [Node]()
    weak var parent:Node?
    
    override init() {
        super.init()
    }
    
    init(_ title: String) {
        self.title = title
    }
    
    func isLeaf() -> Bool {
        return children.isEmpty
    }
    
}
