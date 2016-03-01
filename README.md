# AccordionMenu
The aim of this project is learn how to build an Accordion Menu in Swift using the `UITableView`.

## Initial Setting

For the sake of brevety in the use of the project I've created an initial data source of rows of `String` type, one array called `topItems` for the parents cells and another array called `subItems` to specificy the child cells for each parent cell in this case of `[[String]]`.

```swift
/// The data source for the parent cell.
var topItems = [String]()

/// The data source for the child cells.
var subItems = [[String]]()
```
    
The data source is initialized inside the function `setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int)` where it's assigned the number of the row for each parent cell and the number of the child cell for each parent cell.

```swift
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
        let random = Int(arc4random_uniform(UInt32(childs + 1))) + 1
        
        // create the array for each cell
        return (0..<random).enumerate().map {"Subitem \($0.index)"}
    })
}
```

The number of cells for each parent cell is taken as a random number between `[0..numberOfRowChildPerParent]` to create a different  each number of childs for each parent cell.

## Expanding or collapsing a cell

Every time we tap on a parent cell the cell can be expanded or collapsed, because every time we expand a cell the `NSIndexPath` or the remaining cells change we need to calculate where is the parent index for the tapped cell using the function `findParent(index : Int) -> Int`

```swift
/**
 Find the index of the parent cell for the index of a cell.
 
 - parameter index: The index of the cell to find the parent
 
 - returns: The index of parent cell.
 */
private func findParent(index : Int) -> Int {
    
    var parent = 0
    var i = 0
    
    while (true) {
        
        if (i >= index) {
            return parent
        }
        
        // if it's expanded the cell
        if let _ = self.currentItemsExpanded.indexOf(parent) {
            
            // sum its childs and continue
            i += self.subItems[parent].count + 1
            
            if (i > index) {
                return parent
            }
        }
        else {
            i += 1
        }
        parent += 1
    }
}
```

For this objective, we keep a record in the array `currentItemsExpanded` of the indexes for the cells expanded so far. In this way we can calculate based in the number of cells expanded before the cell what was its original position. 

Then using the function `setExpandeOrCollapsedStateforCell(parent: Int, index: Int)` we can know if the cell it's expanded or collapsed and change its state. 

```swift
/**
 Send the execution to collapse or expand the cell with parent and index specified.
 
 - parameter parent: The parent of the cell.
 - parameter index:  The index of the cell.
 */
private func setExpandeOrCollapsedStateforCell(parent: Int, index: Int) {
    
    // if the cell is expanded
    if let value = self.currentItemsExpanded.indexOf(parent) {
        
        self.collapseSubItemsAtIndex(index)
        self.actualPositions[parent] = -1
        
        // remove the parent from the expanded list
        self.currentItemsExpanded.removeAtIndex(value)
        
        for i in parent + 1..<self.topItems.count {
            if self.actualPositions[i] != -1 {
                self.actualPositions[i] -= self.subItems[parent].count
            }
        }
    }
    else {
        
        self.expandItemAtIndex(index)
        self.actualPositions[parent] = index
        
        for i in parent + 1..<self.topItems.count {
            if self.actualPositions[i] != -1 {
                self.actualPositions[i] += self.subItems[parent].count
            }
        }
        
        // add the parent for the expanded list
        self.currentItemsExpanded.append(parent)
    }
}
```

It's good to mention that always we change the cell in case of being a parent cell, it's verified inside the `didSelectRowAtIndexPath` method. 

```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    guard !self.isChildCell(indexPath) else {
        NSLog("A child was tapped!!!");
        return
    }
    
    self.tableView.beginUpdates()
    
    let parent = self.findParent(indexPath.row)
    self.setExpandeOrCollapsedStateforCell(parent, index: indexPath.row)
    
    self.tableView.endUpdates()
}
```
---
# Feedback

## I've found a bug, or have a feature request

Please raise a [GitHub issue](https://github.com/Vkt0r/AccordionMenu/issues). 😱

## Interested in contributing?

Great! Please launch a [pull request](https://github.com/Vkt0r/AccordionMenu/pulls). 👍

---------------------------------------
© 2015 - 2016 Victor Sigler

 
