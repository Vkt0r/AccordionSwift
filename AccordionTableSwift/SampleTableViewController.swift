//
//  SampleTableViewController.swift
//  AccordionTableSwift
//
//  Created by Victor on 7/5/16.
//  Copyright © 2016 Pentlab. All rights reserved.
//

import UIKit

class SampleTableViewController: AccordionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Parent(state: .Collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 1")
        let item2 = Parent(state: .Collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 2")
        let item3 = Parent(state: .Collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 3")
        let item4 = Parent(state: .Collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 4")
        let item5 = Parent(state: .Collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 5")
        
        self.dataSource = [item1, item2, item3, item4, item5]
        self.total = dataSource.count
        self.numberOfCellsExpanded = .Several
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
