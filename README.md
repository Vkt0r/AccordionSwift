# AccordionMenu

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org)
[![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/)

![Screenshot](https://github.com/Vkt0r/AccordionMenu/blob/master/ezgif.com-gif-maker.gif)

## Initial Setting

For the sake of brevety in the use of the project I've created an initial data source of rows of `Parent`, it's a struct defined in the following way: 

```swift
/**
 *  The Parent struct of the data source.
 */
struct Parent {
    
    /// State of the cell
    var state: State
    
    /// The childs of the cell
    var childs: [String]
    
    /// The title for the cell.
    var title: String
}
```

The enum `State` is used to keep the state for each parent cell.

```swift
/**
 Define the state of a cell
 
 - Collapsed: Cell collapsed
 - Expanded:  Cell expanded
 */
enum State {
    case Collapsed
    case Expanded
}
```
    
The data source is initialized inside the function `setInitialDataSource(numberOfRowParents:numberOfRowChildPerParent:)` where it's assigned the number of the row for each parent cell and the number of the child cell for each parent cell.

```swift
/**
 Set the initial data for test the table view.
 
 - parameter parents: The number of parents cells
 - parameter childs:  Then maximun number of child cells per parent.
 */
private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
    
    // Set the total of cells initially.
    self.total = parents
    
    let data = [Parent](count: parents, repeatedValue: Parent(state: .Collapsed, childs: [String](), title: ""))
    
    dataSource = data.enumerate().map({ (index: Int, var element: Parent) -> Parent in
        
        element.title = "Item \(index)"
        
        // generate the random number between 0...childs
        let random = Int(arc4random_uniform(UInt32(childs + 1))) + 1
        
        // create the array for each cell
        element.childs = (0..<random).enumerate().map {"Subitem \($0.index)"}
        
        return element
    })
}
```

The number of cells for each parent cell is taken as a random number between `[0..numberOfRowChildPerParent]` to create a different  each number of childs for each parent cell.

## Only one cell tapped at time or severals

We have created the enum `NumberOfCellExpanded` with the purpose of provide an easy way to customize the number of cells tapped at each time.

```swift
**
 Enum to define the number of cell expanded at time
 
 - One:     One cell expanded at time.
 - Several: Several cells expanded at time.
 */
enum NumberOfCellExpanded {
    case One
    case Several
}
```

In the class `AccordionMenuTableViewController` we have defined the constant `numberOfCellsExpanded` to set where only one cell can be expanded at time or not.


```swift
/// Define wether can exist several cells expanded or not.
let numberOfCellsExpanded: NumberOfCellExpanded = .One
```

## Expanding or collapsing a cell

Every time we tap on a parent cell the cell can change it state to expanded or collapsed, when we expand a cell the `NSIndexPath` for the remaining cells change, so we need to calculate where is the parent index for the tapped cell using the function `findParent(_:)`

```swift
/**
 Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
 
 - parameter index: The index of the cell
 
 - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
 */
private func findParent(index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
    
    var position = 0, parent = 0
    guard position < index else { return (parent, true, parent) }
    
    var item = self.dataSource[parent]
    
    repeat {
        
        switch (item.state) {
        case .Expanded:
            position += item.childs.count + 1
        case .Collapsed:
            position += 1
        }
        
        parent += 1
        
        // if is not outside of dataSource boundaries
        if parent < self.dataSource.count {
            item = self.dataSource[parent]
        }
        
    } while (position < index)
    
    // if it's a parent cell the indexes are equal.
    if position == index {
        return (parent, position == index, position)
    }
    
    item = self.dataSource[parent - 1]
    return (parent - 1, position == index, position - item.childs.count - 1)
}
```

The above function returns a tuple of `(Int, Bool, Int)` with the values for the parent of cell, if the cell is a parent cell or not and the actual position of the parent in the list of expanded and collapsed cells.

Then using the function `updateCells(_:index:)` we update the cell regarding if it's expanded or collapsed. 

```swift
/**
 Update the cells to expanded to collapsed state in case of allow severals cells expanded.
 
 - parameter parent: The parent of the cell
 - parameter index:  The index of the cell.
 */
private func updateCells(parent: Int, index: Int) {
    
    switch (self.dataSource[parent].state) {
        
    case .Expanded:
        self.collapseSubItemsAtIndex(index, parent: parent)
        self.lastCellExpanded = NoCellExpanded
        
    case .Collapsed:
        switch (numberOfCellsExpanded) {
        case .One:
            // exist one cell expanded previously
            if self.lastCellExpanded != NoCellExpanded {
                
                let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                
                self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                
                // cell tapped is below of previously expanded, then we need to update the index to expand.
                if parent > parentOfCellExpanded {
                    let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                    self.expandItemAtIndex(newIndex, parent: parent)
                    self.lastCellExpanded = (newIndex, parent)
                }
                else {
                    self.expandItemAtIndex(index, parent: parent)
                    self.lastCellExpanded = (index, parent)
                }
            }
            else {
                self.expandItemAtIndex(index, parent: parent)
                self.lastCellExpanded = (index, parent)
            }
        case .Several:
            self.expandItemAtIndex(index, parent: parent)
        }
    }
}
```

It's good to mention that always we change the cell in case of being a parent cell, it's verified inside the `tableView(_:didSelectRowAtIndexPath:)` method. 

```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let (parent, isParentCell, _) = self.findParent(indexPath.row)
    
    guard isParentCell else {
        NSLog("A child was tapped!!!")
        return
    }
    
    self.tableView.beginUpdates()
    self.updateCells(parent, index: indexPath.row)
    self.tableView.endUpdates()
}
```

## Height for the parent and child cells

The height for the parent cells and child cell can be modified in an easy way using the function `tableView(_:heightForRowAtIndexPath:)` according to your needs.

```swift
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 44.0 : 64.0
}
```

---
# Feedback

## I've found a bug, or have a feature request

Please raise a [GitHub issue](https://github.com/Vkt0r/AccordionMenu/issues). 😱

## Interested in contributing?

Great! Please launch a [pull request](https://github.com/Vkt0r/AccordionMenu/pulls). 👍

---------------------------------------

License:
=================
The MIT License. See the LICENSE file for more infomation.

 
