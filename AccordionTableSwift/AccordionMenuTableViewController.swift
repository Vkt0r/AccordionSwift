//
//  AccordionMenuTableViewController.swift
//  AccordionTableSwift
//
//  Created by Victor Sigler on 2/4/15.
//  Copyright (c) 2015 Private. All rights reserved.
//

import UIKit

class AccordionMenuTableViewController: UITableViewController {
    
    /// The data source for the parent cell.
    var topItems = [String]()
    
    /// The data source for the child cells.
    var subItems = [[String]]()
    
    /// The position for the current items expanded.
    var currentItemsExpanded = [Int]()
    
    /// The originals positions of each parent cell.
    var actualPositions: [Int]!
    
    /// The number of elements in the data source
    var total = 0
    
    /// The identifier for the parent cells.
    let parentCellIdentifier = "ParentCell"
    
    
    /// The identifier for the child cells.
    let childCellIdentifier = "ChildCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialDataSource(numberOfRowParents: 10, numberOfRowChildPerParent: 3)
    }
    
    /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        // Init the array with all the values in -1
        self.actualPositions = [Int](count: parents, repeatedValue: -1)
        
        // Create an array with the element "Item index".
        self.topItems = (0..<parents).enumerate().map { "Item \($0.0 + 1)"}
        
        // Create the array of childs using a random number between 0..childs+1 for each parent.
        self.subItems = (0..<parents).map({ _ -> [String] in
            
            // generate the random number between 0...childs
            let random = Int(arc4random_uniform(UInt32(childs + 1)))
            
            // create the array for each cell
            return (0..<random).enumerate().map {"Subitem \($0.index)"}
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func expandItemAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let val = self.findParent(index)
        
        let currentSubItems = self.subItems[val]
        var insertPos = index + 1
        
        for (var i = 0; i < currentSubItems.count; i++) {
            indexPaths.append(NSIndexPath(forRow: insertPos++, inSection: 0))
        }
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total += self.subItems[val].count
    }
    
    private func collapseSubItemsAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        let parent = self.findParent(index)
        
        for (var i = index + 1; i <= index + self.subItems[parent].count; i++ ){
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total  -= self.subItems[parent].count
    }
    
    
    private func findParent(index : Int) -> Int {
        
        var parent = 0
        var i = 0
        
        while (true) {
            
            if (i >= index) {
                break
            }
            
            // if is opened
            if let _ = self.currentItemsExpanded.indexOf(parent) {
                i += self.subItems[parent].count + 1
                
                if (i > index) {
                    break
                }
            }
            else {
                ++i
            }
            
            ++parent
        }
        
        return parent
    }
}

extension AccordionMenuTableViewController {
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        
        let isChild = idx != nil && indexPath.row != self.actualPositions[parent]
        
        var cell : UITableViewCell!
        
        if isChild {
            cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = self.subItems[parent][indexPath.row - self.actualPositions[parent] - 1]
            cell.backgroundColor = UIColor.greenColor()
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            let topIndex = self.findParent(indexPath.row)
            
            cell.textLabel!.text = self.topItems[topIndex]
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        var isChild = idx != nil
        
        if indexPath.row == self.actualPositions[parent]{
            isChild = false
        }
        
        if (isChild) {
            NSLog("A child was tapped!!!");
            return;
        }
        
        self.tableView.beginUpdates()
        
        if let value = self.currentItemsExpanded.indexOf(self.findParent(indexPath.row)) {
            
            self.collapseSubItemsAtIndex(indexPath.row)
            self.actualPositions[parent] = -1
            self.currentItemsExpanded.removeAtIndex(value)
                  
            for i in parent + 1..<self.topItems.count {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] -= self.subItems[parent].count
                }
            }
        }
        else {
            let parent = self.findParent(indexPath.row)
            
            self.expandItemAtIndex(indexPath.row)
            self.actualPositions[parent] = indexPath.row
            
            for i in parent + 1..<self.topItems.count {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] += self.subItems[parent].count
                }
            }
            
            self.currentItemsExpanded.append(parent)
        }
        
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        
        let isChild = idx != nil && indexPath.row != self.actualPositions[parent]
        
        if (isChild) {
            return 44.0
        }
        return 64.0
    }
}
