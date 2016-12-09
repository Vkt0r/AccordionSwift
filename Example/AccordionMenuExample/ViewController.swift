//
//  ViewController.swift
//  AccordionMenuSwift
//
//  Created by Victor Sigler on 11/20/2016.
//  Copyright (c) 2016 Victor Sigler. All rights reserved.
//

import UIKit
import AccordionMenuSwift


class ViewController: AccordionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let item1 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 1")
        let item2 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 2")
        let item3 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 3")
        let item4 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 4")
        let item5 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 5")
        
        self.dataSource = [item1, item2, item3, item4, item5]
        self.numberOfCellsExpanded = .one
        
    }
}

