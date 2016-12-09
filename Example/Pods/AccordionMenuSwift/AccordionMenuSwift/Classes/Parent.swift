//
//  Parent.swift
//  AccordionMenu
//
//  Created by Victor on 7/6/16.
//  Copyright © 2016 Victor Sigler. All rights reserved.
//

/**
 Define the state of a cell
 
 - Collapsed: Cell collapsed
 - Expanded:  Cell expanded
 */
public enum State {
    case collapsed
    case expanded
}

/**
 Enum to define the number of cell expanded at time
 
 - One:     One cell expanded at time.
 - Several: Several cells expanded at time.
 */
public enum NumberOfCellExpanded {
    case one
    case several
}

/**
 *  The Parent struct of the data source.
 */
public struct Parent {
    
    /// State of the cell
    var state: State
    
    /// The childs of the cell
    var childs: [String]
    
    /// The title for the cell.
    var title: String
    
    public init(state: State, childs: [String], title: String) {
        self.state = state
        self.childs = childs
        self.title = title
    }
}

/**
 Overload for the operator != for tuples
 
 - parameter lhs: The first tuple to compare
 - parameter rhs: The seconde tuple to compare
 
 - returns: true if there are different, otherwise false
 */
public func != (lhs: (Int, Int), rhs: (Int, Int)) -> Bool {
    return lhs.0 != rhs.0 && rhs.1 != lhs.1
}
